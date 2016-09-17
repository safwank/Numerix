defmodule Numerix.LinearRegression do
  @moduledoc """
  Linear regression functions.
  """

  import Numerix.Statistics
  alias Numerix.Correlation

  @doc """
  Least squares best fit for points `{x, y}` to a line `y:x↦a+bx`
  where `x` is the predictor and `y` the response.

  Returns a tuple containing the intercept `a` and slope `b`.
  """
  @spec fit([number], [number]) :: {float, float}
  def fit([], _), do: nil
  def fit(_, []), do: nil
  def fit(xs, ys) when length(xs) != length(ys), do: nil
  def fit(xs, ys) do
    x_mean = xs |> mean
    y_mean = ys |> mean
    variance = xs |> variance
    covariance = xs |> covariance(ys)
    slope = covariance / variance
    intercept = y_mean - (slope * x_mean)
    {intercept, slope}
  end

  @doc """
  Measures how close the observed data are to
  the fitted regression line, i.e. how accurate
  the prediction is given the actual data.

  Returns a value between 0 and 1 where 0 indicates
  a prediction that is worse than the mean and 1
  indicates a perfect prediction.
  """
  @spec r_squared([number], [number]) :: float
  def r_squared(predicted, actual) do
    predicted
    |> Correlation.pearson(actual)
    |> squared
  end

  defp squared(nil), do: nil
  defp squared(correlation), do: correlation |> :math.pow(2)
end
