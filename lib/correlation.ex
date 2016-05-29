defmodule Numerix.Correlation do
  alias Numerix.Math

  @moduledoc """
  Statistical correlation functions between two vectors.
  """

  @doc """
  Calculates the Pearson correlation coefficient between two vectors.
  """
  @spec pearson([number], [number]) :: float | :error
  def pearson([], _), do: :error
  def pearson(_, []), do: :error
  def pearson(vector1, vector2) do
    sum1 = vector1 |> Enum.sum
    sum2 = vector2 |> Enum.sum

    sum_of_squares1 = vector1 |> square |> Enum.sum
    sum_of_squares2 = vector2 |> square |> Enum.sum

    sum_of_products =
      vector1
      |> Stream.zip(vector2)
      |> Stream.map(fn {x, y} -> x * y end)
      |> Enum.sum

    size = length(vector1)
    num = sum_of_products - (sum1 * sum2 / size)
    density = :math.sqrt(
      (sum_of_squares1 - :math.pow(sum1, 2) / size)
      * (sum_of_squares2 - :math.pow(sum2, 2) / size))

    case density do
      0.0 -> 0.0
      _ -> num / density
    end
  end

  @doc """
  Calculates the weighted Pearson correlation coefficient between two vectors.
  """
  @spec pearson([number], [number], [number]) :: float | :error
  def pearson([], _, _), do: :error
  def pearson(_, [], _), do: :error
  def pearson(_, _, []), do: :error
  def pearson(vector1, vector2, weights) do
    weighted_covariance_xy = weighted_covariance(vector1, vector2, weights)
    weighted_covariance_xx = weighted_covariance(vector1, vector1, weights)
    weighted_covariance_yy = weighted_covariance(vector2, vector2, weights)

    weighted_covariance_xy
    |> Math.divide(:math.sqrt(weighted_covariance_xx * weighted_covariance_yy))
  end

  defp square(vector) do
    vector |> Enum.map(&:math.pow(&1, 2))
  end

  defp weighted_covariance(vector1, vector2, weights) do
    weighted_mean1 = weighted_mean(vector1, weights)
    weighted_mean2 = weighted_mean(vector2, weights)

    vector1
    |> Stream.zip(vector2)
    |> Stream.zip(weights)
    |> Stream.map(fn {{x, y}, w} -> w * (x - weighted_mean1) * (y - weighted_mean2) end)
    |> Enum.sum
    |> Math.divide(weights |> Enum.sum)
  end

  defp weighted_mean(vector, weights) do
    vector
    |> Stream.zip(weights)
    |> Stream.map(fn {x, w} -> x * w end)
    |> Enum.sum
    |> Math.divide(weights |> Enum.sum)
  end

end
