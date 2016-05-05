defmodule Numerix.CorrelationTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Correlation

  property :pearson_correlation_is_between_minus_1_and_1 do
    for_all {xs, ys} in {list(number), list(number)} do
      implies ListHelper.non_empty_lists_of_equal_length?(xs, ys) do
        distance = Correlation.pearson(xs, ys)
        distance >= -1 && distance <= 1
      end
    end
  end

end
