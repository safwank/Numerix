defmodule Numerix.Correlation do
  @moduledoc """
  Statistical correlation functions between two vectors.
  """

  use Numerix.Tensor

  import Numerix.LinearAlgebra

  alias Numerix.{Common, Statistics}

  @doc """
  Calculates the Pearson correlation coefficient between two vectors.
  """
  @spec pearson(Common.vector(), Common.vector()) :: Common.maybe_float()
  def pearson(%Tensor{items: []}, _), do: nil
  def pearson(_, %Tensor{items: []}), do: nil
  def pearson(%Tensor{items: x}, %Tensor{items: y}) when length(x) != length(y), do: nil

  def pearson(x = %Tensor{}, y = %Tensor{}) do
    sum1 = sum(x)
    sum2 = sum(y)
    sum_of_squares1 = sum(pow(x, 2))
    sum_of_squares2 = sum(pow(y, 2))
    sum_of_products = dot(x, y)

    size = Enum.count(x.items)
    num = sum_of_products - sum1 * sum2 / size

    density =
      :math.sqrt(
        (sum_of_squares1 - :math.pow(sum1, 2) / size) *
          (sum_of_squares2 - :math.pow(sum2, 2) / size)
      )

    case density do
      0.0 -> 0.0
      _ -> num / density
    end
  end

  def pearson(vector1, vector2) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    pearson(x, y)
  end

  @doc """
  Calculates the weighted Pearson correlation coefficient between two vectors.
  """
  @spec pearson(Common.vector(), Common.vector(), Common.vector()) :: Common.maybe_float()
  def pearson(%Tensor{items: []}, _, _), do: nil
  def pearson(_, %Tensor{items: []}, _), do: nil
  def pearson(_, _, %Tensor{items: []}), do: nil
  def pearson([], _, _), do: nil
  def pearson(_, [], _), do: nil
  def pearson(_, _, []), do: nil

  def pearson(vector1, vector2, weights) do
    weighted_covariance_xy = Statistics.weighted_covariance(vector1, vector2, weights)
    weighted_covariance_xx = Statistics.weighted_covariance(vector1, vector1, weights)
    weighted_covariance_yy = Statistics.weighted_covariance(vector2, vector2, weights)
    weighted_covariance_xy / :math.sqrt(weighted_covariance_xx * weighted_covariance_yy)
  end
end
