defmodule Numerix.Distance do
  @moduledoc """
  Distance functions between two vectors.
  """

  alias Numerix.{Common, Correlation, Math}

  @doc """
  The Pearson's distance between two vectors.
  """
  @spec pearson([number], [number]) :: Common.maybe_float
  def pearson(vector1, vector2) do
    case Correlation.pearson(vector1, vector2) do
      nil -> nil
      correlation -> 1.0 - correlation
    end
  end

  @doc """
  The Minkowski distance between two vectors.
  """
  @spec minkowski([number], [number], integer) :: Common.maybe_float
  def minkowski(vector1, vector2, lambda \\ 3)
  def minkowski([], _, _lambda), do: nil
  def minkowski(_, [], _lambda), do: nil
  def minkowski(vector1, vector2, lambda) do
    vector1
    |> Stream.zip(vector2)
    |> Stream.map(fn {x, y} -> :math.pow(abs(x - y), lambda) end)
    |> Enum.sum
    |> Math.nth_root(lambda)
  end

  @doc """
  The Euclidean distance between two vectors.
  """
  @spec euclidean([number], [number]) :: Common.maybe_float
  def euclidean(vector1, vector2) do
    minkowski(vector1, vector2, 2)
  end

  @doc """
  The Manhattan distance between two vectors.
  """
  @spec manhattan([number], [number]) :: Common.maybe_float
  def manhattan(vector1, vector2) do
    minkowski(vector1, vector2, 1)
  end

  @doc """
  The Jaccard distance (1 - Jaccard index) between two vectors.
  """
  @spec jaccard([number], [number]) :: Common.maybe_float
  def jaccard([], []), do: 0.0
  def jaccard([], _), do: nil
  def jaccard(_, []), do: nil
  def jaccard(vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Enum.reduce({0, 0}, fn {x, y}, {intersection, union} ->
      case {x, y} do
        {x, y} when x == 0 or y == 0 ->
          {intersection, union}
        {x, y} when x == y ->
          {intersection + 1, union + 1}
        _ ->
          {intersection, union + 1}
      end
    end)
    |> to_jaccard_distance
  end

  defp to_jaccard_distance({intersection, union}) do
    1 - (intersection / union)
  end

end
