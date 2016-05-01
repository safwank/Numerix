defmodule Numerix.Distance do
  alias Numerix.Correlation

  @typedoc "Something that may be a float."
  @type maybe_float :: float | :error

  @doc "Calculates the Pearson's distance between two vectors."
  @spec pearson([number], [number]) :: maybe_float
  def pearson(vector1, vector2) do
    case Correlation.pearson(vector1, vector2) do
      :error -> :error
      correlation -> 1.0 - correlation
    end
  end

  @doc "Calculates the Euclidean distance between two vectors."
  @spec euclidean([number], [number]) :: maybe_float
  def euclidean(vector1, vector2) do
    distance(vector1, vector2, fn v1, v2 ->
      v1
      |> Stream.zip(v2)
      |> Stream.map(fn {x, y} -> :math.pow(x - y, 2) end)
      |> Enum.sum
      |> :math.sqrt
    end)
  end

  @doc "Calculates the Manhattan distance between two vectors."
  @spec manhattan([number], [number]) :: maybe_float
  def manhattan(vector1, vector2) do
    distance(vector1, vector2, fn v1, v2 ->
      v1
      |> Stream.zip(v2)
      |> Stream.map(fn {x, y} -> abs(x - y) end)
      |> Enum.sum
    end)
  end

  defp distance([], _, _fun), do: :error
  defp distance(_, [], _fun), do: :error
  defp distance(vector1, vector2, fun), do: fun.(vector1, vector2)

end
