defmodule Numerix.CorrelationTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.Correlation

  property :pearson_correlation_is_between_minus_1_and_1 do
    for_all {xs, ys} in {non_empty(list(int)), non_empty(list(int))} do
      {xs, ys} = ListHelper.equalize_length(xs, ys)
      distance = Correlation.pearson(xs, ys)
      distance >= -1 and distance <= 1
    end
  end

end
