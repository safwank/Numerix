defmodule Numerix.StatisticsTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Statistics

  test :mean_is_nil_when_list_is_empty do
    refute Statistics.mean([])
  end

  property :mean_times_item_count_equals_sum do
    for_all xs in non_empty(list(number)) do
      mean = Float.round(Statistics.mean(xs) * length(xs), 4)
      sum = Float.round(Enum.sum(xs) / 1, 4)
      mean == sum
    end
  end

  property :mean_is_between_mix_and_max do
    for_all xs in non_empty(list(number)) do
      mean = Statistics.mean(xs)
      mean >= Enum.min(xs) and mean <= Enum.max(xs)
    end
  end

  test :median_is_nil_when_list_is_empty do
    refute Statistics.median([])
  end

  property :median_is_the_middle_value_of_a_sorted_list do
    for_all xs in non_empty(list(number)) do
      xs = Enum.uniq(xs)
      median = Statistics.median(xs)
      {first, second} = xs |> Enum.sort |> Enum.split_while(fn x -> x <= median end)
      (length(first) == length(second)) or (length(first) - 1 == length(second))
    end
  end

  property :median_is_between_mix_and_max do
    for_all xs in non_empty(list(number)) do
      median = Statistics.median(xs)
      median >= Enum.min(xs) and median <= Enum.max(xs)
    end
  end

  test :mode_is_nil_when_list_is_empty do
    refute Statistics.mode([])
  end

  property :mode_is_nil_if_no_value_is_repeated do
    for_all xs in non_empty(list(number)) do
      xs |> Enum.uniq |> Statistics.mode == nil
    end
  end

  property :mode_is_the_most_frequent_value do
    for_all {x, xs} in {number, non_empty(list(number))} do
      frequent = [x]
      frequent_list = frequent |> Stream.cycle |> Enum.take(length(xs) + 1)
      xs |> Enum.concat(frequent_list) |> Enum.shuffle |> Statistics.mode == frequent
    end
  end

  property :mode_is_the_most_frequent_set_of_values do
    for_all {x, y, xs} in such_that({x_, y_, _} in {number, number, non_empty(list(number))} when x_ < y_) do
      frequent_set = [x, y]
      frequent_list = frequent_set |> Stream.cycle |> Enum.take(2 * (length(xs) + 1))

      xs
      |> Enum.reject(&(Enum.member?(frequent_set, &1)))
      |> Enum.concat(frequent_list)
      |> Enum.shuffle
      |> Statistics.mode
      |> Enum.sort == frequent_set
    end
  end

  test :range_is_nil_when_list_is_empty do
    refute Statistics.range([])
  end

  property :range_is_the_difference_between_the_largest_and_smallest_values do
    for_all xs in non_empty(list(number)) do
      sorted_xs = Enum.sort(xs)
      Statistics.range(xs) == List.last(sorted_xs) - List.first(sorted_xs)
    end
  end

  test :variance_is_nil_when_list_is_empty do
    refute Statistics.variance([])
  end

  test :variance_is_nil_when_list_has_only_one_element do
    refute Statistics.variance([42])
  end

  property :variance_is_the_square_of_standard_deviation do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      xs |> Statistics.variance |> Float.round(4) ==
        xs |> Statistics.std_dev |> :math.pow(2) |> Float.round(4)
    end
  end

  test :population_variance_is_nil_when_list_is_empty do
    refute Statistics.population_variance([])
  end

  property :population_variance_is_the_square_of_population_standard_deviation do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      xs |> Statistics.population_variance |> Float.round(4) ==
        xs |> Statistics.population_std_dev |> :math.pow(2) |> Float.round(4)
    end
  end

  test :std_dev_is_nil_when_list_is_empty do
    refute Statistics.std_dev([])
  end

  test :std_dev_is_nil_when_list_has_only_one_element do
    refute Statistics.std_dev([42])
  end

  test :std_dev_is_correct_for_specific_datasets do
    dataset1 = DataHelper.read("Lew")
    dataset2 = DataHelper.read("Lottery")

    assert_in_delta(dataset1[:data] |> Statistics.std_dev, dataset1[:std_dev], 0.0001)
    assert_in_delta(dataset2[:data] |> Statistics.std_dev, dataset2[:std_dev], 0.0001)
  end

  test :population_std_dev_is_nil_when_list_is_empty do
    refute Statistics.population_std_dev([])
  end

  test :kurtosis_is_nil_when_list_is_empty do
    refute Statistics.kurtosis([])
  end

  test :kurtosis_is_correct_for_specific_datasets do
    dataset1 = DataHelper.read("Lew")
    dataset2 = DataHelper.read("Lottery")

    assert_in_delta(dataset1[:data] |> Statistics.kurtosis, -1.49604979214447, 0.01)
    assert_in_delta(dataset2[:data] |> Statistics.kurtosis, -1.19256091074856, 0.01)
  end

  test :skewness_is_nil_when_list_is_empty do
    refute Statistics.skewness([])
  end

  test :skewness_is_correct_for_specific_datasets do
    dataset1 = DataHelper.read("Lew")
    dataset2 = DataHelper.read("Lottery")

    assert_in_delta(dataset1[:data] |> Statistics.skewness, -0.050606638756334, 0.001)
    assert_in_delta(dataset2[:data] |> Statistics.skewness, -0.09333165310779, 0.001)
  end

  test :covariance_is_nil_when_any_list_is_empty do
    refute Statistics.covariance([], [1, 2])
    refute Statistics.covariance([1, 2], [])
  end

  test :covariance_is_nil_when_any_list_has_only_one_element do
    refute Statistics.covariance([1], [2, 3])
    refute Statistics.covariance([1, 2], [3])
  end

  test :covariance_is_nil_when_the_list_lengths_do_not_match do
    refute Statistics.covariance([1, 2], [3, 4, 5])
    refute Statistics.covariance([1, 2, 3], [4, 5])
  end

  property :covariance_is_consistent_with_variance do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      assert_in_delta(Statistics.covariance(xs, xs), Statistics.variance(xs), 0.0000000001)
    end
  end

  property :covariance_is_symmetric do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number)), non_empty(list(number))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = ListHelper.equalize_length(xs, ys)
      Statistics.covariance(xs, ys) == Statistics.covariance(ys, xs)
    end
  end

  test :population_covariance_is_nil_when_any_list_is_empty do
    refute Statistics.population_covariance([], [1, 2])
    refute Statistics.population_covariance([1, 2], [])
  end

  test :population_covariance_is_nil_when_the_list_lengths_do_not_match do
    refute Statistics.population_covariance([1, 2], [3, 4, 5])
    refute Statistics.population_covariance([1, 2, 3], [4, 5])
  end

  property :population_covariance_is_consistent_with_population_variance do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      assert_in_delta(Statistics.population_covariance(xs, xs), Statistics.population_variance(xs), 0.0000000001)
    end
  end

  property :population_covariance_is_symmetric do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number)), non_empty(list(number))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = ListHelper.equalize_length(xs, ys)
      Statistics.population_covariance(xs, ys) == Statistics.population_covariance(ys, xs)
    end
  end

  test :quantile_is_nil_when_list_is_empty do
    refute Statistics.quantile([], 0.5)
  end

  test :quantile_is_nil_when_tau_is_invalid do
    refute Statistics.quantile([1, 2, 3], -0.1)
    refute Statistics.quantile([1, 2, 3], -1.1)
  end

  property :quantile_is_between_mix_and_max_values do
    for_all {xs, tau} in {non_empty(list(number)), int(0, 100)} do
      tau = tau / 100
      {minimum, maximum} = Enum.min_max(xs)

      quantile = Statistics.quantile(xs, tau)
      quantile >= minimum and quantile <= maximum
    end
  end

  test :quantile_is_correct_for_specific_examples do
    xs = [-1, 5, 0, -3, 10, -0.5, 4, 0.2, 1, 6]

    [{0, -3}, {1, 10}, {0.5, 3/5}, {0.2, -4/5}, {0.7, 137/30},
     {0.01, -3}, {0.99, 10}, {0.52, 287/375}, {0.325, -37/240}]
    |> Enum.each(fn {tau, expected} ->
      assert_in_delta(Statistics.quantile(xs, tau), expected, 0.0001)
    end)
  end

  test :percentile_is_nil_when_list_is_empty do
    refute Statistics.percentile([], 50)
  end

  test :percentile_is_nil_when_p_is_invalid do
    refute Statistics.percentile([1, 2, 3], -1)
    refute Statistics.percentile([1, 2, 3], -101)
  end

  property :percentile_is_between_mix_and_max_values do
    for_all {xs, p} in {non_empty(list(number)), int(0, 100)} do
      {minimum, maximum} = Enum.min_max(xs)

      percentile = Statistics.percentile(xs, p)
      percentile >= minimum and percentile <= maximum
    end
  end

  property :percentile_is_consistent_with_quantile do
    for_all {xs, p} in {non_empty(list(number)), int(0, 100)} do
      tau = p / 100

      Statistics.percentile(xs, p) == Statistics.quantile(xs, tau)
    end
  end

  test :weighted_mean_is_nil_when_any_list_is_empty do
    refute Statistics.weighted_mean([], [1, 2])
    refute Statistics.weighted_mean([1, 2], [])
  end

  test :weighted_mean_is_nil_when_the_list_lengths_do_not_match do
    refute Statistics.weighted_mean([1, 2], [3, 4, 5])
    refute Statistics.weighted_mean([1, 2, 3], [4, 5])
  end

  property :weighted_mean_is_consistent_with_arithmetic_mean do
    for_all {xs, w} in {non_empty(list(int)), pos_integer} do
      weights = [w] |> Stream.cycle |> Enum.take(length(xs))

      Statistics.weighted_mean(xs, weights) == Statistics.mean(xs)
    end
  end

  test :weighted_mean_is_correct_for_a_specific_dataset do
    xs = [1, 3, 5, 6, 8, 9]
    weights = [1.0, 0.8, 1.0, 0.9, 1.0, 0.66]

    assert_in_delta(Statistics.weighted_mean(xs, weights), 5.175, 0.001)
  end

end
