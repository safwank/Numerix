defmodule Numerix.Distance do
  @moduledoc """
  Distance functions between two vectors.
  """

  alias Numerix.Correlation
  alias Numerix.Math

  @typedoc """
  Something that may be a float.
  """
  @type maybe_float :: float | nil

  @doc """
  Calculates the Pearson's distance between two vectors.
  """
  @spec pearson([number], [number]) :: maybe_float
  def pearson(vector1, vector2) do
    case Correlation.pearson(vector1, vector2) do
      nil -> nil
      correlation -> 1.0 - correlation
    end
  end

  @doc """
  Calculates the Minkowski distance between two vectors.
  """
  @spec minkowski([number], [number], integer) :: maybe_float
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
  Calculates the Euclidean distance between two vectors.
  """
  @spec euclidean([number], [number]) :: maybe_float
  def euclidean(vector1, vector2) do
    minkowski(vector1, vector2, 2)
  end

  @doc """
  Calculates the Manhattan distance between two vectors.
  """
  @spec manhattan([number], [number]) :: maybe_float
  def manhattan(vector1, vector2) do
    minkowski(vector1, vector2, 1)
  end

end
