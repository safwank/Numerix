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

  def max(x) do
    x.items
    |> List.flatten()
    |> Enum.max()
  end

  def sum(x) do
    x.items
    |> List.flatten()
    |> Enum.sum()
  end

  def ones_like(x) do
    x.items
    |> apply_scalar(fn _ -> 1 end, x.dims)
    |> Tensor.new()
  end

  Enum.each([:exp, :log], fn fun ->
    def unquote(:"#{fun}")(x) do
      x.items
      |> apply_scalar(&apply(:math, unquote(fun), [&1]), x.dims)
      |> Tensor.new()
    end
  end)

  Enum.each([:+, :-], fn op ->
    def unquote(:"#{op}")(x = %Tensor{}) do
      x.items
      |> apply_scalar(&apply(Kernel, unquote(op), [&1]), x.dims)
      |> Tensor.new()
    end

    def unquote(:"#{op}")(x) when is_number(x) do
      apply(Kernel, unquote(op), [x])
    end
  end)

  Enum.each([:+, :-, :*, :/], fn op ->
    def unquote(:"#{op}")(x = %Tensor{}, s) when is_number(s) do
      x.items
      |> apply_scalar(&apply(Kernel, unquote(op), [&1, s]), x.dims)
      |> Tensor.new()
    end

    def unquote(:"#{op}")(s, x = %Tensor{}) when is_number(s) do
      x.items
      |> apply_scalar(&apply(Kernel, unquote(op), [s, &1]), x.dims)
      |> Tensor.new()
    end

    def unquote(:"#{op}")(x = %Tensor{}, y = %Tensor{}) do
      x.items
      |> apply_pairwise(y.items, &apply(Kernel, unquote(op), [&1, &2]), x.dims)
      |> Tensor.new()
    end

    def unquote(:"#{op}")(x, y) when is_number(x) and is_number(y) do
      apply(Kernel, unquote(op), [x, y])
    end
  end)

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

  defp apply_scalar(x, fun, 0) do
    fun.(x)
  end

  defp apply_scalar(items, fun, dim) do
    for i <- items, do: apply_scalar(i, fun, dim - 1)
  end

  defp apply_pairwise(x, y, fun, 0) do
    fun.(x, y)
  end

  defp apply_pairwise(x, y, fun, dim) do
    x
    |> Stream.zip(y)
    |> Enum.map(fn {a, b} ->
      apply_pairwise(a, b, fun, dim - 1)
    end)
  end
end
