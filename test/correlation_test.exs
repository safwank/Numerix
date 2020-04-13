defmodule Numerix.CorrelationTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper

  alias Numerix.Correlation

  describe "pearson" do
    test "is nil when any vector is empty" do
      refute Correlation.pearson([], [1])
      refute Correlation.pearson([2], [])
      refute Correlation.pearson([], [])
    end

    test "is nil when the vectors are not the same size" do
      refute Correlation.pearson([1, 2, 3], [4, 5, 6, 7])
    end

    property "is zero when the vectors are equal but variance is zero" do
      check all(
              x <- integer(),
              len <- integer(1..255)
            ) do
        xs = [x] |> Stream.cycle() |> Enum.take(len)

        assert Correlation.pearson(xs, xs) == 0.0
      end
    end

    property "is one when the vectors are equal and variance is not zero" do
      check all(xs <- uniq_list_of(integer(), min_length: 2, max_tries: 20)) do
        assert Correlation.pearson(xs, xs) == 1.0
      end
    end

    property "is between -1 and 1" do
      check all(
              length <- integer(1..255),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length)
            ) do
        assert Correlation.pearson(xs, ys) |> between?(-1, 1)
      end
    end

    test "is correct for a specific dataset" do
      vector1 = DataHelper.read("Lew") |> Map.get(:data) |> Enum.take(200)
      vector2 = DataHelper.read("Lottery") |> Map.get(:data) |> Enum.take(200)

      assert Correlation.pearson(vector1, vector2) == -0.02947086158072648
    end
  end

  describe "weighted pearson" do
    test "is nil when any vector is empty" do
      refute Correlation.pearson([], [1], [2])
      refute Correlation.pearson([1], [], [2])
      refute Correlation.pearson([1], [2], [])
      refute Correlation.pearson([], [], [])
    end

    test "with constant weights is consistent with unweighted correlation" do
      vector1 = DataHelper.read("Lew") |> Map.get(:data) |> Enum.take(200)
      vector2 = DataHelper.read("Lottery") |> Map.get(:data) |> Enum.take(200)
      weights = [2.0] |> Stream.cycle() |> Enum.take(vector1 |> length)

      weighted_correlation = Correlation.pearson(vector1, vector2, weights)
      unweighted_correlation = Correlation.pearson(vector1, vector2)

      assert_in_delta(weighted_correlation, unweighted_correlation, 0.0000000001)
    end
  end
end
