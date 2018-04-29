defmodule Numerix.Distance do
  @moduledoc """
  Distance functions between two vectors.
  """

  use Numerix.Tensor

  import Numerix.LinearAlgebra

  alias Numerix.{Common, Correlation, Statistics}

  @doc """
  Mean squared error, the average of the squares of the errors
  betwen two vectors, i.e. the difference between predicted
  and actual values.
  """
  @spec mse(Common.vector(), Common.vector()) :: Common.maybe_float()
  def mse(x = %Tensor{}, y = %Tensor{}) do
    p = pow(x - y, 2)
    Statistics.mean(p.items)
  end

  def mse(vector1, vector2) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    mse(x, y)
  end

  @doc """
  Root mean square error of two vectors, or simply the
  square root of mean squared error of the same set of
  values. It is a measure of the differences between
  predicted and actual values.
  """
  @spec rmse(Common.vector(), Common.vector()) :: Common.maybe_float()
  def rmse(vector1, vector2) do
    :math.sqrt(mse(vector1, vector2))
  end

  @doc """
  The Pearson's distance between two vectors.
  """
  @spec pearson(Common.vector(), Common.vector()) :: Common.maybe_float()
  def pearson(vector1, vector2) do
    case Correlation.pearson(vector1, vector2) do
      nil -> nil
      correlation -> 1.0 - correlation
    end
  end

  @doc """
  The Minkowski distance between two vectors.
  """
  @spec minkowski(Common.vector(), Common.vector(), integer) :: Common.maybe_float()
  def minkowski(x, y, p \\ 3)

  def minkowski(x = %Tensor{}, y = %Tensor{}, p) do
    norm(p, x - y)
  end

  def minkowski(vector1, vector2, p) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    minkowski(x, y, p)
  end

  @doc """
  The Euclidean distance between two vectors.
  """
  @spec euclidean(Common.vector(), Common.vector()) :: Common.maybe_float()
  def euclidean(x = %Tensor{}, y = %Tensor{}) do
    l2_norm(x - y)
  end

  def euclidean(vector1, vector2) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    euclidean(x, y)
  end

  @doc """
  The Manhattan distance between two vectors.
  """
  @spec manhattan(Common.vector(), Common.vector()) :: Common.maybe_float()
  def manhattan(x = %Tensor{}, y = %Tensor{}) do
    l1_norm(x - y)
  end

  def manhattan(vector1, vector2) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    manhattan(x, y)
  end

  @doc """
  The Jaccard distance (1 - Jaccard index) between two vectors.
  """
  @spec jaccard(Common.vector(), Common.vector()) :: Common.maybe_float()
  def jaccard(%Tensor{items: []}, %Tensor{items: []}), do: 0.0
  def jaccard(%Tensor{items: []}, _), do: nil
  def jaccard(_, %Tensor{items: []}), do: nil
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
    1 - intersection / union
  end
end
