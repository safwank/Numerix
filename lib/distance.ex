defmodule Numerix.Distance do
  alias Statix.Correlation

  @doc "Calculates the Pearson's distance between two vectors."
  def pearson(vector1, vector2), do: 1.0 - Correlation.pearson(vector1, vector2)

  @doc "Calculates the Euclidean distance between two vectors."
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
