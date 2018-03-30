defmodule Numerix.Tensor do
  @moduledoc """
  Defines a data structure for a tensor and its operators.
  """

  alias Numerix.Tensor

  import Kernel, except: [+: 1, -: 1, +: 2, -: 2, *: 2, /: 2]

  defstruct items: [[[]]], dims: 1

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [+: 1, -: 1, +: 2, -: 2, *: 2, /: 2]
      import Numerix.Tensor

      alias Numerix.Tensor
    end
  end

  def new(x) when is_number(x) or is_list(x) do
    %Tensor{items: x, dims: calculate_dims(x)}
  end

  def new(_) do
    raise "Tensor must be a numeric scalar, list or nested list"
  end

  def max_in(x) do
    x.items
    |> List.flatten()
    |> Enum.max()
  end

  def max_between(0, x) do
    fn i -> max(0, i) end
    |> t_apply(x)
  end

  def sum(x) do
    x.items
    |> List.flatten()
    |> Enum.sum()
  end

  def ones_like(x) do
    fn _ -> 1 end
    |> t_apply(x)
  end

  Enum.each([:exp, :log], fn fun ->
    def unquote(:"#{fun}")(x) do
      fn i -> apply(:math, unquote(fun), [i]) end
      |> t_apply(x)
    end
  end)

  Enum.each([:+, :-], fn op ->
    def unquote(:"#{op}")(x = %Tensor{}) do
      fn i -> apply(Kernel, unquote(op), [i]) end
      |> t_apply(x)
    end

    def unquote(:"#{op}")(x) when is_number(x) do
      apply(Kernel, unquote(op), [x])
    end
  end)

  Enum.each([:+, :-, :*, :/], fn op ->
    def unquote(:"#{op}")(x = %Tensor{}, s) when is_number(s) do
      fn i -> apply(Kernel, unquote(op), [i, s]) end
      |> t_apply(x)
    end

    def unquote(:"#{op}")(s, x = %Tensor{}) when is_number(s) do
      fn i -> apply(Kernel, unquote(op), [s, i]) end
      |> t_apply(x)
    end

    def unquote(:"#{op}")(x = %Tensor{}, y = %Tensor{}) do
      fn i, j -> apply(Kernel, unquote(op), [i, j]) end
      |> t_apply(x, y)
    end

    def unquote(:"#{op}")(x, y) when is_number(x) and is_number(y) do
      apply(Kernel, unquote(op), [x, y])
    end
  end)

  def t_apply(fun, x) do
    fun
    |> do_apply(x.items, x.dims)
    |> Tensor.new()
  end

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
  end

  defp do_apply(fun, items, dim) do
    for i <- items, do: do_apply(fun, i, dim - 1)
  end

  defp do_apply(fun, x, y, 0) do
    fun.(x, y)
  end

  defp do_apply(fun, x, y, dim) do
    x
    |> Stream.zip(y)
    |> Enum.map(fn {a, b} ->
      do_apply(fun, a, b, dim - 1)
    end)
  end
end
