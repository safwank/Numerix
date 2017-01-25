defmodule Numerix.Statistics do
  @moduledoc """
  Common statistical functions.
  """

  alias Numerix.Common

  @doc """
  The average of a list of numbers.
  """
  @spec mean([number]) :: Common.maybe_float
  def mean([]), do: nil
  def mean(xs) do
    Enum.sum(xs) / Enum.count(xs)
  end

  @doc """
  The middle value in a list of numbers.
  """
  @spec median([number]) :: Common.maybe_float
  def median([]), do: nil
  def median(xs) do
    middle_index = round((length(xs) / 2)) - 1
    xs |> Enum.sort |> Enum.at(middle_index)
  end

  @doc """
  The most frequent value(s) in a list.
  """
  @spec mode([number]) :: [number] | nil
  def mode([]), do: nil
  def mode(xs) do
    counts = xs |> Enum.reduce(%{}, fn(x, acc) ->
      acc |> Map.update(x, 1, fn count -> count + 1 end)
    end)

    {_, max_count} = counts |> Enum.max_by(fn {_x, count} -> count end)

    case max_count do
      1 -> nil
      _ ->
        counts
        |> Flow.from_enumerable
        |> Flow.filter_map(fn {_x, count} -> count == max_count end,
                           fn {x, _count} -> x end)
        |> Enum.to_list
    end
  end

  @doc """
  The difference between the largest and smallest values in a list.
  """
  @spec range([number]) :: Common.maybe_float
  def range([]), do: nil
  def range(xs) do
    {minimum, maximum} = Enum.min_max(xs)
    maximum - minimum
  end

  @doc """
  The unbiased population variance from a sample.
  It measures how far the vector is spread out from the mean.
  """
  @spec variance([number]) :: Common.maybe_float
  def variance([]), do: nil
  def variance([_x]), do: nil
  def variance(xs) do
    xs
    |> sum_powered_deviations(2)
    |> Kernel./(Enum.count(xs) - 1)
  end

  @doc """
  The variance for a full population.
  It measures how far the vector is spread out from the mean.
  """
  @spec population_variance([number]) :: Common.maybe_float
  def population_variance([]), do: nil
  def population_variance(xs) do
    xs |> moment(2)
  end

  @doc """
  The unbiased standard deviation from a sample.
  It measures the amount of variation of the vector.
  """
  @spec std_dev([number]) :: Common.maybe_float
  def std_dev([]), do: nil
  def std_dev([_x]), do: nil
  def std_dev(xs) do
    xs |> variance |> :math.sqrt
  end

  @doc """
  The standard deviation for a full population.
  It measures the amount of variation of the vector.
  """
  @spec population_std_dev([number]) :: Common.maybe_float
  def population_std_dev([]), do: nil
  def population_std_dev(xs) do
    xs |> population_variance |> :math.sqrt
  end

  @doc """
  The nth moment about the mean for a sample.
  Used to calculate skewness and kurtosis.
  """
  @spec moment([number], pos_integer) :: Common.maybe_float
  def moment([], _), do: nil
  def moment(_, 1), do: 0.0
  def moment(xs, n) do
    xs
    |> sum_powered_deviations(n)
    |> Kernel./(Enum.count(xs))
  end

  @doc """
  The sharpness of the peak of a frequency-distribution curve.
  It defines the extent to which a distribution differs from a normal distribution.
  Like skewness, it describes the shape of a probability distribution.
  """
  @spec kurtosis([number]) :: Common.maybe_float
  def kurtosis([]), do: nil
  def kurtosis(xs) do
    xs
    |> moment(4)
    |> Kernel./(xs |> population_variance |> :math.pow(2))
    |> Kernel.-(3)
  end

  @doc """
  The skewness of a frequency-distribution curve.
  It defines the extent to which a distribution differs from a normal distribution.
  Like kurtosis, it describes the shape of a probability distribution.
  """
  @spec skewness([number]) :: Common.maybe_float
  def skewness([]), do: nil
  def skewness(xs) do
    xs
    |> moment(3)
    |> Kernel./(xs |> population_variance |> :math.pow(1.5))
  end

  @doc """
  Calculates the unbiased covariance from two sample vectors.
  It is a measure of how much the two vectors change together.
  """
  @spec covariance([number], [number]) :: Common.maybe_float
  def covariance([], _), do: nil
  def covariance(_, []), do: nil
  def covariance([_x], _), do: nil
  def covariance(_, [_y]), do: nil
  def covariance(xs, ys) when length(xs) != length(ys), do: nil
  def covariance(xs, ys) do
    divisor = Enum.count(xs) - 1
    do_covariance(xs, ys, divisor)
  end

  @doc """
  Calculates the population covariance from two full population vectors.
  It is a measure of how much the two vectors change together.
  """
  @spec population_covariance([number], [number]) :: Common.maybe_float
  def population_covariance([], _), do: nil
  def population_covariance(_, []), do: nil
  def population_covariance(xs, ys) when length(xs) != length(ys), do: nil
  def population_covariance(xs, ys) do
    divisor = Enum.count(xs)
    do_covariance(xs, ys, divisor)
  end

  @doc """
  Estimates the tau-th quantile from the vector.
  Approximately median-unbiased irrespective of the sample distribution.
  This implements the R-8 type of https://en.wikipedia.org/wiki/Quantile.
  """
  @spec quantile([number], number) :: Common.maybe_float
  def quantile([], _tau), do: nil
  def quantile(_xs, tau) when tau < 0 or tau > 1, do: nil
  def quantile(xs, tau) do
    sorted_xs = xs |> Enum.sort
    h = (length(sorted_xs) + 1/3) * tau + 1/3
    hf = h |> Float.floor |> round
    do_quantile(sorted_xs, h, hf)
  end

  @doc """
  Estimates the p-Percentile value from the vector.
  Approximately median-unbiased irrespective of the sample distribution.
  This implements the R-8 type of https://en.wikipedia.org/wiki/Quantile.
  """
  @spec percentile([number], integer) :: Common.maybe_float
  def percentile([], _p), do: nil
  def percentile(_xs, p) when p < 0 or p > 100, do: nil
  def percentile(xs, p) do
    quantile(xs, p / 100)
  end

  @doc """
  Calculates the weighted measure of how much two vectors change together.
  """
  @spec weighted_covariance([number], [number], [number]) :: Common.maybe_float
  def weighted_covariance([], _, _), do: nil
  def weighted_covariance(_, [], _), do: nil
  def weighted_covariance(_, _, []), do: nil
  def weighted_covariance(xs, ys, weights)
    when length(xs) != length(ys) or length(xs) != length(weights), do: nil
  def weighted_covariance(xs, ys, weights) do
    weighted_mean1 = weighted_mean(xs, weights)
    weighted_mean2 = weighted_mean(ys, weights)

    xs
    |> Stream.zip(ys)
    |> Stream.zip(weights)
    |> Flow.from_enumerable
    |> Flow.map(fn {{x, y}, w} -> w * (x - weighted_mean1) * (y - weighted_mean2) end)
    |> Enum.sum
    |> Kernel./(weights |> Enum.sum)
  end

  @doc """
  Calculates the weighted average of a list of numbers.
  """
  @spec weighted_mean([number], [number]) :: Common.maybe_float
  def weighted_mean([], _), do: nil
  def weighted_mean(_, []), do: nil
  def weighted_mean(xs, weights) when length(xs) != length(weights), do: nil
  def weighted_mean(xs, weights) do
    xs
    |> Stream.zip(weights)
    |> Flow.from_enumerable
    |> Flow.map(fn {x, w} -> x * w end)
    |> Enum.sum
    |> Kernel./(weights |> Enum.sum)
  end

  defp sum_powered_deviations(xs, n) do
    x_mean = mean(xs)
    xs
    |> Flow.from_enumerable
    |> Flow.map(fn x -> :math.pow(x - x_mean, n) end)
    |> Enum.sum
  end

  defp do_covariance(xs, ys, divisor) do
    mean_x = mean(xs)
    mean_y = mean(ys)

    xs
    |> Stream.zip(ys)
    |> Flow.from_enumerable
    |> Flow.map(fn {x, y} -> (x - mean_x) * (y - mean_y) end)
    |> Enum.sum
    |> Kernel./(divisor)
  end

  defp do_quantile([head | _], _h, hf) when hf < 1, do: head
  defp do_quantile(xs, _h, hf) when hf >= length(xs), do: xs |> List.last
  defp do_quantile(xs, h, hf) do
    (Enum.at(xs, hf - 1)) + (h - hf) * (Enum.at(xs, hf) - Enum.at(xs, hf - 1))
  end
end
