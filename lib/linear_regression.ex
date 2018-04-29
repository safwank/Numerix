defmodule Numerix.LinearRegression do
  @moduledoc """
  Linear regression functions.
  """

  use Numerix.Tensor

  import Numerix.Statistics

  alias Numerix.{Common, Correlation}

  @doc """
  Least squares best fit for points `{x, y}` to a line `y:x↦a+bx`
  where `x` is the predictor and `y` the response.

  Returns a tuple containing the intercept `a` and slope `b`.
  """
  @spec fit(Common.vector(), Common.vector()) :: {float, float}
  def fit(%Tensor{items: []}, _), do: nil
  def fit(_, %Tensor{items: []}), do: nil
  def fit(%Tensor{items: x}, %Tensor{items: y}) when length(x) != length(y), do: nil

  def fit(x = %Tensor{}, y = %Tensor{}) do
    x_mean = mean(x.items)
    y_mean = mean(y.items)
    variance = variance(x.items)
    covariance = covariance(x.items, y.items)
    slope = covariance / variance
    intercept = y_mean - slope * x_mean
    {intercept, slope}
  end

  def fit(xs, ys) do
    x = Tensor.new(xs)
    y = Tensor.new(ys)
    fit(x, y)
  end

  @doc """
  Estimates a response `y` given a predictor `x`
  and a set of predictors and responses, i.e.
  it calculates `y` in `y:x↦a+bx`.
  """
  @spec predict(number, Common.vector(), Common.vector()) :: number
  def predict(x, xs, ys) do
    {intercept, slope} = fit(xs, ys)
    intercept + slope * x
  end

  @doc """
  Measures how close the observed data are to
  the fitted regression line, i.e. how accurate
  the prediction is given the actual data.

  Returns a value between 0 and 1 where 0 indicates
  a prediction that is worse than the mean and 1
  indicates a perfect prediction.
  """
  @spec r_squared(Common.vector(), Common.vector()) :: float
  def r_squared(predicted, actual) do
    predicted
    |> Correlation.pearson(actual)
    |> squared
  end

  defp squared(nil), do: nil
  defp squared(correlation), do: :math.pow(correlation, 2)
end
