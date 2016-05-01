defmodule Numerix.Distance do
  alias Statix.Correlation

  @doc "Calculates the Pearson's distance between two vectors."
  def pearson(vector1, vector2), do: 1.0 - Correlation.pearson(vector1, vector2)

  @doc "Calculates the Euclidean distance between two vectors."
  def euclidean([], _), do: :error
  def euclidean(_, []), do: :error
  def euclidean(vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Stream.map(fn {x, y} -> :math.pow(x - y, 2) end)
    |> Enum.sum
    |> :math.sqrt
  end

  @doc "Calculates the Manhattan distance between two vectors."
  def manhattan([], _), do: :error
  def manhattan(_, []), do: :error
  def manhattan(vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Stream.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum
  end

end
