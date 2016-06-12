defmodule Numerix.Statistics do
  @moduledoc """
  Common statistical functions.
  """

  alias Numerix.Math

  @typedoc """
  Something that may be a float.
  """
  @type maybe_float :: float | :error

  @doc """
  Calculates the average of a list of numbers.
  """
  @spec mean([number]) :: maybe_float
  def mean([]), do: :error
  def mean(xs) do
    Enum.sum(xs) / Enum.count(xs)
  end

  @doc """
  Returns the middle value in a list of numbers.
  """
  @spec median([number]) :: number
  def median([]), do: :error
  def median(xs) do
    middle_index = round((length(xs) / 2)) - 1
    xs |> Enum.sort |> Enum.at(middle_index)
  end

  @doc """
  Calculates the most frequent value(s) in a list.
  """
  @spec mode([number]) :: [number] | nil
  def mode([]), do: :error
  def mode(xs) do
    counts = xs |> Enum.reduce(%{}, fn(x, acc) ->
      acc |> Map.update(x, 1, fn count -> count + 1 end)
    end)

    {_, max_count} = counts |> Enum.max_by(fn {_x, count} -> count end)

    case max_count do
      1 -> nil
      _ -> counts
           |> Enum.filter_map(fn {_x, count} -> count == max_count end,
                              fn {x, _count} -> x end)
    end
  end

  @doc """
  Calculates the difference between the largest and smallest values in a list.
  """
  @spec range([number]) :: number
  def range([]), do: :error
  def range(xs) do
    {minimum, maximum} = Enum.min_max(xs)
    maximum - minimum
  end

  @doc """
  Calculates the unbiased population variance from a sample vector.
  """
  @spec variance([number]) :: maybe_float
  def variance([]), do: :error
  def variance([_x]), do: :error
  def variance(xs) do
    xs
    |> Enum.map(fn x -> :math.pow(x - mean(xs), 2) end)
    |> Enum.sum
    |> Math.divide(Enum.count(xs) - 1)
  end

  @doc """
  Calculates the population variance from a full population vector.
  """
  @spec population_variance([number]) :: maybe_float
  def population_variance([]), do: :error
  def population_variance(xs) do
    xs
    |> Enum.map(fn x -> :math.pow(x - mean(xs), 2) end)
    |> Enum.sum
    |> Math.divide(Enum.count(xs))
  end

  @doc """
  Calculates the unbiased standard deviation from a sample vector.
  """
  @spec std_dev([number]) :: maybe_float
  def std_dev([]), do: :error
  def std_dev([_x]), do: :error
  def std_dev(xs) do
    xs |> variance |> :math.sqrt
  end

  @doc """
  Calculates the population standard deviation from a full population vector.
  """
  @spec population_std_dev([number]) :: maybe_float
  def population_std_dev([]), do: :error
  def population_std_dev(xs) do
    xs |> population_variance |> :math.sqrt
  end

  @doc """
  Calculates the unbiased covariance from two sample vectors.
  """
  @spec covariance([number], [number]) :: maybe_float
  def covariance([], _), do: :error
  def covariance(_, []), do: :error
  def covariance([_x], _), do: :error
  def covariance(_, [_y]), do: :error
  def covariance(xs, ys) when length(xs) != length(ys), do: :error
  def covariance(xs, ys) do
    mean_x = mean(xs)
    mean_y = mean(ys)

    xs
    |> Stream.zip(ys)
    |> Stream.map(fn {x, y} -> (x - mean_x) * (y - mean_y) end)
    |> Enum.sum
    |> Math.divide(length(xs) - 1)
  end

  @doc """
  Calculates the population covariance from two full population vectors.
  """
  @spec population_covariance([number], [number]) :: maybe_float
  def population_covariance([], _), do: :error
  def population_covariance(_, []), do: :error
  def population_covariance(xs, ys) when length(xs) != length(ys), do: :error
  def population_covariance(xs, ys) do
    mean_x = mean(xs)
    mean_y = mean(ys)

    xs
    |> Stream.zip(ys)
    |> Stream.map(fn {x, y} -> (x - mean_x) * (y - mean_y) end)
    |> Enum.sum
    |> Math.divide(length(xs))
  end

  @doc """
  Estimates the tau-th quantile from the vector.
  Approximately median-unbiased irrespective of the sample distribution.
  This implements the R-8 type of https://en.wikipedia.org/wiki/Quantile.
  """
  @spec quantile([number], number) :: maybe_float
  def quantile([], _tau), do: :error
  def quantile(_xs, tau) when tau < 0 or tau > 1, do: :error
  def quantile(xs, tau) do
    sorted_xs = xs |> Enum.sort
    h = (length(sorted_xs) + 1/3) * tau + 1/3
    hf = h |> Float.floor |> round
    do_quantile(sorted_xs, h, hf)
  end

  @doc """
  Calculates the weighted measure of how much two vectors change together.
  """
  @spec weighted_covariance([number], [number], [number]) :: maybe_float
  def weighted_covariance([], _, _), do: :error
  def weighted_covariance(_, [], _), do: :error
  def weighted_covariance(_, _, []), do: :error
  def weighted_covariance(xs, ys, weights)
    when length(xs) != length(ys) or length(xs) != length(weights), do: :error
  def weighted_covariance(xs, ys, weights) do
    weighted_mean1 = weighted_mean(xs, weights)
    weighted_mean2 = weighted_mean(ys, weights)

    xs
    |> Stream.zip(ys)
    |> Stream.zip(weights)
    |> Stream.map(fn {{x, y}, w} -> w * (x - weighted_mean1) * (y - weighted_mean2) end)
    |> Enum.sum
    |> Math.divide(weights |> Enum.sum)
  end

  @doc """
  Calculates the weighted average of a list of numbers.
  """
  @spec weighted_mean([number], [number]) :: maybe_float
  def weighted_mean([], _), do: :error
  def weighted_mean(_, []), do: :error
  def weighted_mean(xs, weights) when length(xs) != length(weights), do: :error
  def weighted_mean(xs, weights) do
    xs
    |> Stream.zip(weights)
    |> Stream.map(fn {x, w} -> x * w end)
    |> Enum.sum
    |> Math.divide(weights |> Enum.sum)
  end

  defp do_quantile([head | _], _h, hf) when hf < 1, do: head
  defp do_quantile(xs, _h, hf) when hf >= length(xs), do: xs |> List.last
  defp do_quantile(xs, h, hf) do
    (Enum.at(xs, hf - 1)) + (h - hf) * (Enum.at(xs, hf) - Enum.at(xs, hf - 1))
  end

end
