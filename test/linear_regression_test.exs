defmodule Numerix.LinearRegressionTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper
  import Numerix.LinearRegression

  describe "least square fit" do
    test "is nil when any vector is empty" do
      refute fit([], [1, 2, 3])
      refute fit([1, 2, 3], [])
    end

    test "is nil when the vectors aren't the same size" do
      refute fit([1, 2, 3], [4, 5])
    end

    test "is correct for a specific example" do
      {intercept, slope} = fit([1.3, 2.1, 3.7, 4.2], [2.2, 5.8, 10.2, 11.8])

      assert_in_delta(intercept, -1.52256, 0.00001)
      assert_in_delta(slope, 3.19383, 0.00001)
    end
  end

  describe "predict/3" do
    test "is correct for a specific example" do
      predictors = [1, 2.3, 3.1, 4.8, 5.6, 6.3]
      responses = [2.6, 2.8, 3.1, 4.7, 5.1, 5.3]

      assert predict(3.5, predictors, responses) == 3.7288688355893296
    end
  end

  describe "r_squared/2" do
    property "is between 0 and 1" do
      check all(
              length <- integer(1..255),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length)
            ) do
        assert r_squared(xs, ys) |> between?(0, 1)
      end
    end

    property "is 1 when predicted perfectly matches actual" do
      check all(xs <- list_of(float(), min_length: 5)) do
        assert r_squared(xs, xs) |> Float.round(4) == 1.0
      end
    end

    property "is symmetric" do
      check all(
              length <- integer(1..255),
              xs <- list_of(float(), length: length),
              ys <- list_of(float(), length: length)
            ) do
        assert r_squared(xs, ys) |> Float.round(2) == r_squared(ys, xs) |> Float.round(2)
      end
    end

    test "is correct for a specific example" do
      actual = [1, 2.3, 3.1, 4.8, 5.6, 6.3]
      predicted = [2.6, 2.8, 3.1, 4.7, 5.1, 5.3]

      assert r_squared(predicted, actual) == 0.9487852070867371
    end
  end
end
