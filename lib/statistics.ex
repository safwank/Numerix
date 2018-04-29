defmodule Numerix.Statistics do
  @moduledoc """
  Common statistical functions.
  """

  use Numerix.Tensor

  alias Numerix.Common

  @doc """
  The average of a list of numbers.
  """
  @spec mean(Common.vector()) :: Common.maybe_float()
  def mean(%Tensor{items: []}), do: nil

  def mean(x = %Tensor{}) do
    sum(x) / Enum.count(x.items)
  end

  def mean(xs) do
    x = Tensor.new(xs)
    mean(x)
  end

  @doc """
  The middle value in a list of numbers.
  """
  @spec median(Common.vector()) :: Common.maybe_float()
  def median(%Tensor{items: []}), do: nil

  def median(x = %Tensor{}) do
    middle_index = round(length(x.items) / 2) - 1
    x.items |> Enum.sort() |> Enum.at(middle_index)
  end

  def median(xs) do
    x = Tensor.new(xs)
    median(x)
  end

  @doc """
  The most frequent value(s) in a list.
  """
  @spec mode(Common.vector()) :: Common.maybe_vector()
  def mode(%Tensor{items: []}), do: nil

  def mode(x = %Tensor{}) do
    counts =
      Enum.reduce(x.items, %{}, fn i, acc ->
        acc |> Map.update(i, 1, fn count -> count + 1 end)
      end)

    {_, max_count} = counts |> Enum.max_by(fn {_x, count} -> count end)

    case max_count do
      1 ->
        nil

      _ ->
        counts
        |> Stream.filter(fn {_x, count} -> count == max_count end)
        |> Enum.map(fn {i, _count} -> i end)
    end
  end

  def mode(xs) do
    x = Tensor.new(xs)
    mode(x)
  end

  @doc """
  The difference between the largest and smallest values in a list.
  """
  @spec range(Common.vector()) :: Common.maybe_float()
  def range(%Tensor{items: []}), do: nil

  def range(x = %Tensor{}) do
    {minimum, maximum} = Enum.min_max(x.items)
    maximum - minimum
  end

  def range(xs) do
    x = Tensor.new(xs)
    range(x)
  end

  @doc """
  The unbiased population variance from a sample.
  It measures how far the vector is spread out from the mean.
  """
  @spec variance(Common.vector()) :: Common.maybe_float()
  def variance(%Tensor{items: []}), do: nil
  def variance(%Tensor{items: [_x]}), do: nil

  def variance(x = %Tensor{}) do
    sum_powered_deviations(x, 2) / (Enum.count(x.items) - 1)
  end

  def variance(xs) do
    x = Tensor.new(xs)
    variance(x)
  end

  @doc """
  The variance for a full population.
  It measures how far the vector is spread out from the mean.
  """
  @spec population_variance(Common.vector()) :: Common.maybe_float()
  def population_variance(%Tensor{items: []}), do: nil
  def population_variance(x = %Tensor{}), do: moment(x, 2)

  def population_variance(xs) do
    x = Tensor.new(xs)
    population_variance(x)
  end

  @doc """
  The unbiased standard deviation from a sample.
  It measures the amount of variation of the vector.
  """
  @spec std_dev(Common.vector()) :: Common.maybe_float()
  def std_dev(%Tensor{items: []}), do: nil
  def std_dev(%Tensor{items: [_x]}), do: nil
  def std_dev(x = %Tensor{}), do: :math.sqrt(variance(x))

  def std_dev(xs) do
    x = Tensor.new(xs)
    std_dev(x)
  end

  @doc """
  The standard deviation for a full population.
  It measures the amount of variation of the vector.
  """
  @spec population_std_dev(Common.vector()) :: Common.maybe_float()
  def population_std_dev(%Tensor{items: []}), do: nil
  def population_std_dev(x = %Tensor{}), do: :math.sqrt(population_variance(x))

  def population_std_dev(xs) do
    x = Tensor.new(xs)
    population_std_dev(x)
  end

  @doc """
  The nth moment about the mean for a sample.
  Used to calculate skewness and kurtosis.
  """
  @spec moment(Common.vector(), pos_integer) :: Common.maybe_float()
  def moment(%Tensor{items: []}, _), do: nil
  def moment(_, 1), do: 0.0
  def moment(x = %Tensor{}, n), do: sum_powered_deviations(x, n) / Enum.count(x.items)

  def moment(xs, n) do
    x = Tensor.new(xs)
    moment(x, n)
  end

  @doc """
  The sharpness of the peak of a frequency-distribution curve.
  It defines the extent to which a distribution differs from a normal distribution.
  Like skewness, it describes the shape of a probability distribution.
  """
  @spec kurtosis(Common.vector()) :: Common.maybe_float()
  def kurtosis(%Tensor{items: []}), do: nil
  def kurtosis(x = %Tensor{}), do: moment(x, 4) / :math.pow(population_variance(x), 2) - 3

  def kurtosis(xs) do
    x = Tensor.new(xs)
    kurtosis(x)
  end

  @doc """
  The skewness of a frequency-distribution curve.
  It defines the extent to which a distribution differs from a normal distribution.
  Like kurtosis, it describes the shape of a probability distribution.
  """
  @spec skewness(Common.vector()) :: Common.maybe_float()
  def skewness(%Tensor{items: []}), do: nil
  def skewness(x = %Tensor{}), do: moment(x, 3) / :math.pow(population_variance(x), 1.5)

  def skewness(xs) do
    x = Tensor.new(xs)
    skewness(x)
  end

  @doc """
  Calculates the unbiased covariance from two sample vectors.
  It is a measure of how much the two vectors change together.
  """
  @spec covariance(Common.vector(), Common.vector()) :: Common.maybe_float()
  def covariance(%Tensor{items: []}, _), do: nil
  def covariance(_, %Tensor{items: []}), do: nil
  def covariance(%Tensor{items: [_x]}, _), do: nil
  def covariance(_, %Tensor{items: [_y]}), do: nil
  def covariance(%Tensor{items: x}, %Tensor{items: y}) when length(x) != length(y), do: nil

  def covariance(x = %Tensor{}, y = %Tensor{}) do
    divisor = Enum.count(x.items) - 1
    do_covariance(x, y, divisor)
  end

  def covariance(xs, ys) do
    x = Tensor.new(xs)
    y = Tensor.new(ys)
    covariance(x, y)
  end

  @doc """
  Calculates the population covariance from two full population vectors.
  It is a measure of how much the two vectors change together.
  """
  @spec population_covariance(Common.vector(), Common.vector()) :: Common.maybe_float()
  def population_covariance(%Tensor{items: []}, _), do: nil
  def population_covariance(_, %Tensor{items: []}), do: nil

  def population_covariance(%Tensor{items: x}, %Tensor{items: y}) when length(x) != length(y),
    do: nil

  def population_covariance(x = %Tensor{}, y = %Tensor{}) do
    divisor = Enum.count(x.items)
    do_covariance(x, y, divisor)
  end

  def population_covariance(xs, ys) do
    x = Tensor.new(xs)
    y = Tensor.new(ys)
    population_covariance(x, y)
  end

  @doc """
  Estimates the tau-th quantile from the vector.
  Approximately median-unbiased irrespective of the sample distribution.
  This implements the R-8 type of https://en.wikipedia.org/wiki/Quantile.
  """
  @spec quantile(Common.vector(), number) :: Common.maybe_float()
  def quantile(%Tensor{items: []}, _tau), do: nil
  def quantile(_xs, tau) when tau < 0 or tau > 1, do: nil

  def quantile(x = %Tensor{}, tau) do
    sorted_x = Enum.sort(x.items)
    h = (length(sorted_x) + 1 / 3) * tau + 1 / 3
    hf = h |> Float.floor() |> round
    do_quantile(sorted_x, h, hf)
  end

  def quantile(xs, tau) do
    x = Tensor.new(xs)
    quantile(x, tau)
  end

  @doc """
  Estimates the p-Percentile value from the vector.
  Approximately median-unbiased irrespective of the sample distribution.
  This implements the R-8 type of https://en.wikipedia.org/wiki/Quantile.
  """
  @spec percentile(Common.vector(), integer) :: Common.maybe_float()
  def percentile(%Tensor{items: []}, _p), do: nil
  def percentile(_xs, p) when p < 0 or p > 100, do: nil
  def percentile(x = %Tensor{}, p), do: quantile(x, p / 100)

  def percentile(xs, p) do
    x = Tensor.new(xs)
    percentile(x, p)
  end

  @doc """
  Calculates the weighted measure of how much two vectors change together.
  """
  @spec weighted_covariance(Common.vector(), Common.vector(), Common.vector()) ::
          Common.maybe_float()
  def weighted_covariance(%Tensor{items: []}, _, _), do: nil
  def weighted_covariance(_, %Tensor{items: []}, _), do: nil
  def weighted_covariance(_, _, %Tensor{items: []}), do: nil

  def weighted_covariance(%Tensor{items: x}, %Tensor{items: y}, %Tensor{items: w})
      when length(x) != length(y) or length(x) != length(w),
      do: nil

  def weighted_covariance(x = %Tensor{}, y = %Tensor{}, w = %Tensor{}) do
    weighted_mean1 = weighted_mean(x, w)
    weighted_mean2 = weighted_mean(y, w)
    sum(w * (x - weighted_mean1) * (y - weighted_mean2)) / sum(w)
  end

  def weighted_covariance(xs, ys, weights) do
    x = Tensor.new(xs)
    y = Tensor.new(ys)
    w = Tensor.new(weights)
    weighted_covariance(x, y, w)
  end

  @doc """
  Calculates the weighted average of a list of numbers.
  """
  @spec weighted_mean(Common.vector(), Common.vector()) :: Common.maybe_float()
  def weighted_mean(%Tensor{items: []}, _), do: nil
  def weighted_mean(_, %Tensor{items: []}), do: nil
  def weighted_mean(%Tensor{items: x}, %Tensor{items: w}) when length(x) != length(w), do: nil
  def weighted_mean(x = %Tensor{}, w = %Tensor{}), do: sum(x * w) / sum(w)

  def weighted_mean(xs, weights) do
    x = Tensor.new(xs)
    w = Tensor.new(weights)
    weighted_mean(x, w)
  end

  defp sum_powered_deviations(x, n) do
    x_mean = mean(x)
    sum(pow(x - x_mean, n))
  end

  defp do_covariance(x, y, divisor) do
    mean_x = mean(x)
    mean_y = mean(y)
    sum((x - mean_x) * (y - mean_y)) / divisor
  end

  defp do_quantile([head | _], _h, hf) when hf < 1, do: head
  defp do_quantile(xs, _h, hf) when hf >= length(xs), do: List.last(xs)

  defp do_quantile(xs, h, hf) do
    Enum.at(xs, hf - 1) + (h - hf) * (Enum.at(xs, hf) - Enum.at(xs, hf - 1))
  end
end
