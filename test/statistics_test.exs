defmodule Numerix.StatisticsTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Statistics

  test :mean_is_zero_when_list_is_empty do
    assert Statistics.mean([]) == 0
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

  test :median_is_zero_when_list_is_empty do
    assert Statistics.median([]) == 0
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
    assert Statistics.mode([]) == nil
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
      frequent = [x, y]
      frequent_list = frequent |> Stream.cycle |> Enum.take(2 * (length(xs) + 1))
      xs
      |> Enum.reject(&(Enum.member?(frequent, &1)))
      |> Enum.concat(frequent_list)
      |> Enum.shuffle
      |> Statistics.mode
      |> Enum.sort == frequent
    end
  end

  test :range_is_zero_when_list_is_empty do
    assert Statistics.range([]) == 0
  end

  property :range_is_the_difference_between_the_largest_and_smallest_values do
    for_all xs in non_empty(list(number)) do
      sorted_xs = Enum.sort(xs)
      Statistics.range(xs) == List.last(sorted_xs) - List.first(sorted_xs)
    end
  end

  property :variance_is_the_square_of_standard_deviation do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      xs |> Statistics.variance |> Float.round(4) ==
        xs |> Statistics.std_dev |> :math.pow(2) |> Float.round(4)
    end
  end

  property :population_variance_is_the_square_of_population_standard_deviation do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      xs |> Statistics.population_variance |> Float.round(4) ==
        xs |> Statistics.population_std_dev |> :math.pow(2) |> Float.round(4)
    end
  end

  test :std_dev_is_correct_for_specific_datasets do
    dataset1 = DataHelper.read("Lew")
    dataset2 = DataHelper.read("Lottery")

    assert_in_delta(dataset1[:data] |> Statistics.std_dev, dataset1[:std_dev], 0.0001)
    assert_in_delta(dataset2[:data] |> Statistics.std_dev, dataset2[:std_dev], 0.0001)
  end

  property :covariance_is_consistent_with_variance do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      assert_in_delta(Statistics.covariance(xs, xs), Statistics.variance(xs), 0.0000000001)
    end
  end

  property :population_covariance_is_consistent_with_population_variance do
    for_all xs in such_that(xxs in non_empty(list(number)) when length(xxs) > 1) do
      assert_in_delta(Statistics.population_covariance(xs, xs), Statistics.population_variance(xs), 0.0000000001)
    end
  end

  property :covariance_is_symmetric do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number)), non_empty(list(number))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = ListHelper.equalize_length(xs, ys)
      Statistics.covariance(xs, ys) == Statistics.covariance(ys, xs)
    end
  end

  property :population_covariance_is_symmetric do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number)), non_empty(list(number))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = ListHelper.equalize_length(xs, ys)
      Statistics.population_covariance(xs, ys) == Statistics.population_covariance(ys, xs)
    end
  end

end
