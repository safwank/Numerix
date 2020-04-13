defmodule Numerix.DistanceTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper

  alias Numerix.{Correlation, Distance}

  describe "mse/2" do
    test "is correct for a specific example" do
      vector1 = [12, 15, 20, 22, 24]
      vector2 = [13, 17, 18, 20, 24]
      assert Distance.mse(vector1, vector2) == 2.6
    end

    property "is 0 when the vectors are equal" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Distance.mse(xs, xs) == 0
      end
    end

    property "is not 0 when the vectors are different" do
      check all(
              length <- integer(1..50),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length),
              xs != ys
            ) do
        assert Distance.mse(xs, ys) != 0
      end
    end
  end

  describe "rmse/2" do
    test "is correct for a specific example" do
      vector1 = [7, 10, 12, 10, 10, 8, 7, 8, 11, 13, 10, 8]
      vector2 = [6, 10, 14, 16, 7, 5, 5, 13, 12, 13, 8, 5]
      assert Distance.rmse(vector1, vector2) == 2.9154759474226504
    end

    property "is 0 when the vectors are equal" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Distance.rmse(xs, xs) == 0
      end
    end

    property "is not 0 when the vectors are different" do
      check all(
              length <- integer(1..50),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length),
              xs != ys
            ) do
        assert Distance.rmse(xs, ys) != 0
      end
    end
  end

  describe "pearson/2" do
    test "is nil when any vector is empty" do
      refute Distance.pearson([], [1])
      refute Distance.pearson([2], [])
      refute Distance.pearson([], [])
    end

    property "is the inverse of its correlation" do
      check all(
              length <- integer(1..50),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length),
              xs != ys
            ) do
        assert Distance.pearson(xs, ys) == 1.0 - Correlation.pearson(xs, ys)
      end
    end

    property "is between 0 and 2" do
      check all(
              length <- integer(1..50),
              xs <- list_of(integer(), length: length),
              ys <- list_of(integer(), length: length),
              xs != ys
            ) do
        assert Distance.pearson(xs, ys) |> between?(0, 2)
      end
    end
  end

  describe "minkowski/2" do
    test "is 0 when any vector is empty" do
      assert Distance.minkowski([], [1]) == 0
      assert Distance.minkowski([2], []) == 0
      assert Distance.minkowski([], []) == 0
    end

    property "is 0 when the vectors are equal" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Distance.minkowski(xs, xs) == 0
      end
    end

    test "is correct for a specific dataset when using the default lambda" do
      vector1 = [1, 3, 5, 6, 8, 9]
      vector2 = [2, 5, 6, 6, 7, 7]

      assert Distance.minkowski(vector1, vector2) == 2.6684016487219897
    end

    test "is correct for a specific dataset when using a different lambda" do
      vector1 = [1, 3, 5, 6, 8, 9]
      vector2 = [2, 5, 6, 6, 7, 7]
      lambda = 5

      assert Distance.minkowski(vector1, vector2, lambda) == 2.3185419629968713
    end
  end

  describe "euclidean/2" do
    test "is 0 when any vector is empty" do
      assert Distance.euclidean([], [1]) == 0
      assert Distance.euclidean([2], []) == 0
      assert Distance.euclidean([], []) == 0
    end

    property "is 0 when the vectors are equal" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Distance.euclidean(xs, xs) == 0
      end
    end

    test "is correct for a specific dataset" do
      vector1 = [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      vector2 = [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      assert Distance.euclidean(vector1, vector2) == 4.2426406871196605
    end
  end

  describe "manhattan/2" do
    test "is 0 when any vector is empty" do
      assert Distance.manhattan([], [1]) == 0
      assert Distance.manhattan([2], []) == 0
      assert Distance.manhattan([], []) == 0
    end

    property "is 0 when the vectors are equal" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Distance.manhattan(xs, xs) == 0
      end
    end

    test "is correct for a specific dataset" do
      vector1 = [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      vector2 = [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      assert Distance.manhattan(vector1, vector2) == 12
    end
  end

  describe "jaccard/2" do
    test "is 0 when both vectors are empty" do
      assert Distance.jaccard([], []) == 0.0
    end

    test "is nil when any one vector is empty" do
      refute Distance.jaccard([], [1])
      refute Distance.jaccard([2], [])
    end

    test "is correct for specific examples" do
      [
        {[0, 0.5], [0.5, 1], 1.0},
        {[4.5, 1], [4, 2], 1.0},
        {[1, 1, 1], [1, 1, 1], 0},
        {[2.5, 3.5, 3.0, 3.5, 2.5, 3.0], [3.0, 3.5, 1.5, 5.0, 3.5, 3.0], 0.6666666666666667},
        {[1, 3, 5, 6, 8, 9, 6, 4, 3, 2], [2, 5, 6, 6, 7, 7, 5, 3, 1, 1], 0.9}
      ]
      |> Enum.each(fn {vector1, vector2, distance} ->
        assert Distance.jaccard(vector1, vector2) == distance
      end)
    end

    property "is between 0 and 1" do
      check all(
              xs <- list_of(integer(0..255), min_length: 1),
              ys <- list_of(integer(0..255), min_length: 1)
            ) do
        assert Distance.jaccard(xs, ys) |> between?(0, 1)
      end
    end
  end
end
