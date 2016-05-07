defmodule Numerix.StatisticsTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Statistics

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

  property :mode_is_the_most_frequent_value do
    for_all xs in non_empty(list(number)) do
      frequent = [6] |> Stream.cycle |> Enum.take(length(xs) + 1)
      xs = xs |> Enum.concat(frequent) |> Enum.shuffle
      Statistics.mode(xs) == 6
    end
  end

  property :mode_is_nil_if_no_value_is_repeated do
    for_all xs in non_empty(list(number)) do
      xs |> Enum.uniq |> Statistics.mode == nil
    end
  end

  property :range_is_the_difference_between_the_largest_and_smallest_values do
    for_all xs in non_empty(list(number)) do
      sorted_xs = Enum.sort(xs)
      Statistics.range(xs) == List.last(sorted_xs) - List.first(sorted_xs)
    end
  end

end
