defmodule Numerix.DistanceTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Distance
  alias Numerix.Correlation

  property :pearson_distance_is_the_inverse_of_its_correlation do
    for_all {xs, ys} in {list(number), list(number)} do
      implies ListHelper.non_empty_lists_of_equal_length?(xs, ys) do
        Distance.pearson(xs, ys) == 1.0 - Correlation.pearson(xs, ys)
      end
    end
  end

  property :pearson_distance_is_between_0_and_2 do
    for_all {xs, ys} in {list(number), list(number)} do
      implies ListHelper.non_empty_lists_of_equal_length?(xs, ys) do
        distance = Distance.pearson(xs, ys)
        distance >= 0 && distance <= 2
      end
    end
  end

end
