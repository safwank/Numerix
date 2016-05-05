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
      mean >= Enum.min(xs) && mean <= Enum.max(xs)
    end
  end

  property :median_is_the_middle_value do
    for_all xs in non_empty(list(pos_integer)) do
      implies ListHelper.unique?(xs) do
        median = Statistics.median(xs)

        if length(xs) == 1 do
          median == List.first(xs)
        else
          {first, second} = xs |> Enum.sort |> Enum.split_while(fn x -> x <= median end)
          (length(first) == length(second)) || (length(first) - 1 == length(second))
        end
      end
    end
  end

  property :median_is_between_mix_and_max do
    for_all xs in non_empty(list(number)) do
      median = Statistics.median(xs)
      median >= Enum.min(xs) && median <= Enum.max(xs)
    end
  end

end
