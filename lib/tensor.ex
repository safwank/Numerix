defmodule Numerix.Tensor do
  @moduledoc """
  Defines a data structure for a tensor and its operations.
  """

  alias Numerix.Tensor

  import Kernel, except: [+: 1, -: 1, abs: 1, +: 2, -: 2, *: 2, /: 2, max: 2]

  @max_long_value 9_223_372_036_854_775_807

  defstruct items: [], dims: 1

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
    %Tensor{items: x, dims: calculate_dims(x)}
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

  @doc """
  Falls back to Elixir's default `max` function.
  """
  def max(first, second) do
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

    @doc """
    Falls back to Elixir's default `#{op}/1` function.
    """
    def unquote(:"#{op}")(x) do
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

    @doc """
    Falls back to Elixir's default `#{op}/2` function.
    """
    def unquote(:"#{op}")(x, y) do
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

  defp calculate_dims(x, dims \\ 0)

  defp calculate_dims(scalar, dims) when is_number(scalar) do
    dims
  end

  defp calculate_dims([], dims) do
    dims + 1
  end

  defp calculate_dims([x | _], dims) do
    calculate_dims(x, dims + 1)
  end

  defp calculate_dims(_, _) do
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
    |> Enum.sort()
    |> Keyword.values()
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
    |> Enum.sort()
    |> Keyword.values()
  end
end
