defmodule Numerix.Correlation do
  @moduledoc """
  Statistical correlation functions between two vectors.
  """

  import Numerix.LinearAlgebra
  alias Numerix.{Common, Statistics}

  @doc """
  Calculates the Pearson correlation coefficient between two vectors.
  """
  @spec pearson([number], [number]) :: Common.maybe_float
  def pearson([], _), do: nil
  def pearson(_, []), do: nil
  def pearson(vector1, vector2) when length(vector1) != length(vector2), do: nil
  def pearson(vector1, vector2) do
    sum1 = vector1 |> Enum.sum
    sum2 = vector2 |> Enum.sum
    sum_of_squares1 = vector1 |> square |> Enum.sum
    sum_of_squares2 = vector2 |> square |> Enum.sum
    sum_of_products = vector1 |> dot_product(vector2)

    size = length(vector1)
    num = sum_of_products - (sum1 * sum2 / size)
    density = (sum_of_squares1 - :math.pow(sum1, 2) / size)
      |> Kernel.*(sum_of_squares2 - :math.pow(sum2, 2) / size)
      |> :math.sqrt

    case density do
      0.0 -> 0.0
      _ -> num / density
    end
  end

  @doc """
  Calculates the weighted Pearson correlation coefficient between two vectors.
  """
  @spec pearson([number], [number], [number]) :: Common.maybe_float
  def pearson([], _, _), do: nil
  def pearson(_, [], _), do: nil
  def pearson(_, _, []), do: nil
  def pearson(vector1, vector2, weights) do
    weighted_covariance_xy = Statistics.weighted_covariance(vector1, vector2, weights)
    weighted_covariance_xx = Statistics.weighted_covariance(vector1, vector1, weights)
    weighted_covariance_yy = Statistics.weighted_covariance(vector2, vector2, weights)

    weighted_covariance_xy
    |> Kernel./(weighted_covariance_xx |> Kernel.*(weighted_covariance_yy) |> :math.sqrt)
  end

  defp square(vector) do
    vector |> Enum.map(&:math.pow(&1, 2))
  end
end
