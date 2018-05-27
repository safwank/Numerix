defmodule Numerix.Tensor do
  @moduledoc """
  Defines a data structure for a tensor and its operations.

  You can construct a `Tensor` by calling `Tensor.new/1` and passing it a list, or a list of lists, or a list of lists of...you get the idea.

  Example

      use Numerix.Tensor

      x = Tensor.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  Once you have a `Tensor` (or three), you can then use it in normal math operations, e.g. elementwise matrix operations.

  Example

      x = Tensor.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      y = Tensor.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      assert x / y == Tensor.new([[1, 1, 1], [1, 1, 1], [1, 1, 1]])

  As it turns out, this is very handy when you need to implement complex math formulae as the code looks more like math functions than noisy code with a bunch of calls to `Enum.map/2`, `Enum.zip/2` and the like.

  Example

      x = Tensor.new([[0, 0.1, 0.5, 0.9, 1.0]])
      m = max(x)
      e = exp(x - m)
      s = sum(e)
      assert e / s == Tensor.new([[0.1119598021340303, 0.12373471731203411, 0.18459050724175335, 0.2753766776533774, 0.30433829565880477]])

  Oh, I should also mention that this API uses `Flow` to parallelize independent pieces of computation to speed things up! Depending on the type of calculations you're doing, the bigger the data and the more cores you have, the faster it gets.
  """

  alias Numerix.Tensor

  import Kernel, except: [+: 1, -: 1, abs: 1, +: 2, -: 2, *: 2, /: 2, max: 2]

  @max_long_value 9_223_372_036_854_775_807

  defstruct items: [], dims: 1, shape: {0}

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [+: 1, -: 1, abs: 1, +: 2, -: 2, *: 2, /: 2, max: 2]
      import Numerix.Tensor

      alias Numerix.Tensor
    end
  end

  @doc """
  Creates a new tensor from the given scalar, list or nested list.
  """
  @spec new(number | [number]) :: %Tensor{} | no_return()
  def new(x) when is_number(x) or is_list(x) do
    shape = x |> calculate_shape |> Enum.reverse()
    %Tensor{items: x, dims: Enum.count(shape), shape: List.to_tuple(shape)}
  end

  def new(x) do
    raise "Tensor must be a numeric scalar, list or nested list, but got #{inspect(x)} instead"
  end

  @doc """
  Returns the biggest element in the given tensor.
  """
  @spec max(%Tensor{}) :: number
  def max(x = %Tensor{}) do
    x.items
    |> List.flatten()
    |> Enum.max()
  end

  @doc """
  Compares the given scalar with each element of the given tensor and returns the biggest of the two.
  """
  @spec max(number, %Tensor{}) :: %Tensor{}
  def max(s, x = %Tensor{}) when is_number(s) do
    fn i -> max(s, i) end
    |> t_apply(x)
  end

  @doc """
  Compares each element of the two given tensors element-wise and returns the biggest value.
  """
  @spec max(%Tensor{}, %Tensor{}) :: %Tensor{}
  def max(x = %Tensor{}, y = %Tensor{}) do
    fn i, j -> max(i, j) end
    |> t_apply(x, y)
  end

  def max(first, second) do
    # Falls back to Elixir's default `max` function.
    Kernel.max(first, second)
  end

  @doc """
  Calculates the sum of all the elements in the given tensor.
  """
  @spec sum(%Tensor{}) :: number
  def sum(x) do
    x.items
    |> List.flatten()
    |> Enum.sum()
  end

  Enum.each([:exp, :log, :sqrt, :tanh], fn fun ->
    @doc """
    Returns the `#{fun}` of the given tensor element-wise.
    """
    def unquote(:"#{fun}")(x) do
      fn i -> apply(:math, unquote(fun), [i]) end
      |> t_apply(x)
    end
  end)

  Enum.each([:pow], fn fun ->
    @doc """
    Returns the result of applying `#{fun}` to the given tensor element-wise.
    """
    def unquote(:"#{fun}")(x = %Tensor{}, s) when is_number(s) do
      fn i -> apply(:math, unquote(fun), [i, s]) end
      |> t_apply(x)
    end
  end)

  Enum.each([:+, :-, :abs], fn op ->
    @doc """
    Returns the result of applying `#{op}` to the given tensor element-wise.
    """
    def unquote(:"#{op}")(x = %Tensor{}) do
      fn i -> apply(Kernel, unquote(op), [i]) end
      |> t_apply(x)
    end

    def unquote(:"#{op}")(x) do
      # Falls back to Elixir's default `#{op}/1` function.
      apply(Kernel, unquote(op), [x])
    end
  end)

  Enum.each([:+, :-, :*, :/], fn op ->
    @doc """
    Returns the result of applying `#{op}` to the given tensor and scalar element-wise.
    """
    def unquote(:"#{op}")(x = %Tensor{}, s) when is_number(s) do
      fn i -> apply(Kernel, unquote(op), [i, s]) end
      |> t_apply(x)
    end

    @doc """
    Returns the result of applying `#{op}` to the given scalar and tensor element-wise.
    """
    def unquote(:"#{op}")(s, x = %Tensor{}) when is_number(s) do
      fn i -> apply(Kernel, unquote(op), [s, i]) end
      |> t_apply(x)
    end

    @doc """
    Returns the result of applying `#{op}` to the given tensors element-wise.
    """
    def unquote(:"#{op}")(x = %Tensor{}, y = %Tensor{}) do
      fn i, j -> apply(Kernel, unquote(op), [i, j]) end
      |> t_apply(x, y)
    end

    def unquote(:"#{op}")(x, y) do
      # Falls back to Elixir's default `#{op}/2` function.
      apply(Kernel, unquote(op), [x, y])
    end
  end)

  @doc """
  Applies the given function to the tensor element-wise and returns the result as a new tensor.
  """
  @spec t_apply(fun(), %Tensor{}) :: %Tensor{}
  def t_apply(fun, x) do
    fun
    |> do_apply(x.items, x.dims)
    |> Tensor.new()
  end

  @doc """
  Applies the given function to the two tensors element-wise and returns the result as a new tensor.
  """
  @spec t_apply(fun(), %Tensor{}, %Tensor{}) :: %Tensor{}
  def t_apply(fun, x, y) do
    fun
    |> do_apply(x.items, y.items, x.dims)
    |> Tensor.new()
  end

  defp calculate_shape(x, shape \\ [])
  defp calculate_shape(x, shape) when is_number(x), do: shape
  defp calculate_shape([], shape), do: [0 | shape]

  defp calculate_shape(x = [y | _], shape) when is_number(y) do
    [length(x) | shape]
  end

  defp calculate_shape(x = [y | _], shape) do
    calculate_shape(y, [length(x) | shape])
  end

  defp calculate_shape(_, _) do
    raise "Tensor must be a numeric scalar, list or nested list"
  end

  defp do_apply(fun, x, 0) do
    fun.(x)
  rescue
    ArithmeticError -> @max_long_value
  end

  defp do_apply(fun, items, dim) do
    items
    |> Enum.with_index()
    |> Flow.from_enumerable()
    |> Flow.map(fn {a, i} -> {i, do_apply(fun, a, dim - 1)} end)
    |> to_ordered_values()
  end

  defp do_apply(fun, x, y, 0) do
    fun.(x, y)
  end

  defp do_apply(fun, x, y, dim) do
    x
    |> Stream.zip(y)
    |> Stream.with_index()
    |> Flow.from_enumerable()
    |> Flow.map(fn {{a, b}, i} ->
      {i, do_apply(fun, a, b, dim - 1)}
    end)
    |> to_ordered_values()
  end

  defp to_ordered_values(flow) do
    flow
    |> Enum.to_list()
    |> List.keysort(0)
    |> Keyword.values()
  end
end
