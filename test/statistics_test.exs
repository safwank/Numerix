defmodule Numerix.StatisticsTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper

  alias Numerix.Statistics

  describe "mean/1" do
    test "is nil when list is empty" do
      refute Statistics.mean([])
    end

    property "times item count equals sum" do
      check all(xs <- list_of(integer(), min_length: 1)) do
        mean = Float.round(Statistics.mean(xs) * length(xs), 4)
        sum = Float.round(Enum.sum(xs) / 1, 4)
        assert mean == sum
      end
    end

    property "is between mix and max" do
      check all(xs <- list_of(integer(), min_length: 1)) do
        assert Statistics.mean(xs) |> between?(Enum.min(xs), Enum.max(xs))
      end
    end
  end

  describe "median/1" do
    test "is nil when list is empty" do
      refute Statistics.median([])
    end

    property "is the middle value of a sorted list" do
      check all(xs <- uniq_list_of(float(), min_length: 1)) do
        median = Statistics.median(xs)
        {first, second} = xs |> Enum.sort() |> Enum.split_while(fn x -> x <= median end)
        assert length(first) == length(second) or length(first) - 1 == length(second)
      end
    end

    property "is between mix and max" do
      check all(xs <- list_of(float(), min_length: 1)) do
        assert Statistics.median(xs) |> between?(Enum.min(xs), Enum.max(xs))
      end
    end
  end

  describe "mode/1" do
    test "is nil when list is empty" do
      refute Statistics.mode([])
    end

    property "is nil if no value is repeated" do
      check all(xs <- uniq_list_of(float(), min_length: 1)) do
        assert Statistics.mode(xs) == nil
      end
    end

    property "is the most frequent value" do
      check all(
              x <- float(),
              xs <- list_of(float(), min_length: 1)
            ) do
        frequent = [x]
        frequent_list = frequent |> Stream.cycle() |> Enum.take(length(xs) + 1)
        assert xs |> Enum.concat(frequent_list) |> Enum.shuffle() |> Statistics.mode() == frequent
      end
    end

    property "is the most frequent set of values" do
      check all(
              x <- integer(-1000..1000),
              y <- integer((x + 1)..1000),
              xs <- list_of(integer(), min_length: 1)
            ) do
        frequent_set = [x, y]
        frequent_list = frequent_set |> Stream.cycle() |> Enum.take(2 * (length(xs) + 1))

        assert xs
               |> Enum.reject(&Enum.member?(frequent_set, &1))
               |> Enum.concat(frequent_list)
               |> Enum.shuffle()
               |> Statistics.mode()
               |> Enum.sort() == frequent_set
      end
    end
  end

  describe "range/1" do
    test "range is nil when list is empty" do
      refute Statistics.range([])
    end

    property "is the difference between the largest and smallest values" do
      check all(
              xs <- list_of(float(), min_length: 1),
              {min, max} = Enum.min_max(xs)
            ) do
        assert Statistics.range(xs) == max - min
      end
    end
  end

  describe "variance/1" do
    test "is nil when list is empty" do
      refute Statistics.variance([])
    end

    test "is nil when list has only one element" do
      refute Statistics.variance([42])
    end

    property "is the square of standard deviation" do
      check all(xs <- list_of(integer(), min_length: 2)) do
        assert xs |> Statistics.variance() |> Float.round(4) ==
                 xs |> Statistics.std_dev() |> :math.pow(2) |> Float.round(4)
      end
    end
  end

  describe "population_variance/1" do
    test "is nil when list is empty" do
      refute Statistics.population_variance([])
    end

    property "is the square of population standard deviation" do
      check all(xs <- list_of(integer(), min_length: 2)) do
        assert xs |> Statistics.population_variance() |> Float.round(4) ==
                 xs |> Statistics.population_std_dev() |> :math.pow(2) |> Float.round(4)
      end
    end
  end

  describe "std_dev/1" do
    test "is nil when list is empty" do
      refute Statistics.std_dev([])
    end

    test "is nil when list has only one element" do
      refute Statistics.std_dev([42])
    end

    test "is correct for specific datasets" do
      dataset1 = DataHelper.read("Lew")
      dataset2 = DataHelper.read("Lottery")

      assert_in_delta(
        dataset1[:data] |> Enum.to_list() |> Statistics.std_dev(),
        dataset1[:std_dev],
        0.0001
      )

      assert_in_delta(
        dataset2[:data] |> Enum.to_list() |> Statistics.std_dev(),
        dataset2[:std_dev],
        0.0001
      )
    end
  end

  describe "population_std_dev/1" do
    test "is nil when list is empty" do
      refute Statistics.population_std_dev([])
    end
  end

  describe "moment/1" do
    test "is correct for a normal list (for coverage)" do
      assert Statistics.moment([1, 2, 3], 10) == 0.6666666666666666
    end
  end

  describe "kurtosis/1" do
    test "is nil when list is empty" do
      refute Statistics.kurtosis([])
    end

    test "is correct for specific datasets" do
      dataset1 = DataHelper.read("Lew")
      dataset2 = DataHelper.read("Lottery")

      assert_in_delta(
        dataset1[:data] |> Enum.to_list() |> Statistics.kurtosis(),
        -1.49604979214447,
        0.01
      )

      assert_in_delta(
        dataset2[:data] |> Enum.to_list() |> Statistics.kurtosis(),
        -1.19256091074856,
        0.01
      )
    end
  end

  describe "skewness/1" do
    test "is nil when list is empty" do
      refute Statistics.skewness([])
    end

    test "is correct for specific datasets" do
      dataset1 = DataHelper.read("Lew")
      dataset2 = DataHelper.read("Lottery")

      assert_in_delta(
        dataset1[:data] |> Enum.to_list() |> Statistics.skewness(),
        -0.050606638756334,
        0.001
      )

      assert_in_delta(
        dataset2[:data] |> Enum.to_list() |> Statistics.skewness(),
        -0.09333165310779,
        0.001
      )
    end
  end

  describe "covariance/2" do
    test "is nil when any list is empty" do
      refute Statistics.covariance([], [1, 2])
      refute Statistics.covariance([1, 2], [])
    end

    test "is nil when any list has only one element" do
      refute Statistics.covariance([1], [2, 3])
      refute Statistics.covariance([1, 2], [3])
    end

    test "is nil when the list lengths do not match" do
      refute Statistics.covariance([1, 2], [3, 4, 5])
      refute Statistics.covariance([1, 2, 3], [4, 5])
    end

    property "is consistent with variance" do
      check all(xs <- list_of(integer(), min_length: 2)) do
        assert_in_delta(Statistics.covariance(xs, xs), Statistics.variance(xs), 0.0000000001)
      end
    end

    property "is symmetric" do
      check all(
              length <- integer(2..255),
              xs <- list_of(float(), length: length),
              ys <- list_of(float(), length: length)
            ) do
        assert Statistics.covariance(xs, ys) == Statistics.covariance(ys, xs)
      end
    end
  end

  describe "population_covariance/2" do
    test "is nil when any list is empty" do
      refute Statistics.population_covariance([], [1, 2])
      refute Statistics.population_covariance([1, 2], [])
    end

    test "is nil when the list lengths do not match" do
      refute Statistics.population_covariance([1, 2], [3, 4, 5])
      refute Statistics.population_covariance([1, 2, 3], [4, 5])
    end

    property "is consistent with population variance" do
      check all(xs <- list_of(integer(), min_length: 2)) do
        assert_in_delta(
          Statistics.population_covariance(xs, xs),
          Statistics.population_variance(xs),
          0.0000000001
        )
      end
    end

    property "is symmetric" do
      check all(
              length <- integer(2..255),
              xs <- list_of(float(), length: length),
              ys <- list_of(float(), length: length)
            ) do
        assert Statistics.population_covariance(xs, ys) ==
                 Statistics.population_covariance(ys, xs)
      end
    end
  end

  describe "quantile/2" do
    test "is nil when list is empty" do
      refute Statistics.quantile([], 0.5)
    end

    test "is nil when tau is invalid" do
      refute Statistics.quantile([1, 2, 3], -0.1)
      refute Statistics.quantile([1, 2, 3], -1.1)
    end

    property "is between mix and max values" do
      check all(
              xs <- list_of(float(), min_length: 1),
              tau <- float(min: 0.0, max: 1.0),
              {min, max} = Enum.min_max(xs)
            ) do
        assert Statistics.quantile(xs, tau) |> between?(min, max)
      end
    end

    test "is correct for specific examples" do
      xs = [-1, 5, 0, -3, 10, -0.5, 4, 0.2, 1, 6]

      [
        {0, -3},
        {1, 10},
        {0.5, 3 / 5},
        {0.2, -4 / 5},
        {0.7, 137 / 30},
        {0.01, -3},
        {0.99, 10},
        {0.52, 287 / 375},
        {0.325, -37 / 240}
      ]
      |> Enum.each(fn {tau, expected} ->
        assert_in_delta(Statistics.quantile(xs, tau), expected, 0.0001)
      end)
    end
  end

  describe "percentile/2" do
    test "is nil when list is empty" do
      refute Statistics.percentile([], 50)
    end

    test "is nil when p is invalid" do
      refute Statistics.percentile([1, 2, 3], -1)
      refute Statistics.percentile([1, 2, 3], -101)
    end

    property "is between mix and max values" do
      check all(
              xs <- list_of(float(), min_length: 1),
              p <- integer(0..100),
              {min, max} = Enum.min_max(xs)
            ) do
        assert Statistics.percentile(xs, p) |> between?(min, max)
      end
    end

    property "is consistent with quantile" do
      check all(
              xs <- list_of(float(), min_length: 1),
              p <- integer(0..100),
              tau = p / 100
            ) do
        assert Statistics.percentile(xs, p) == Statistics.quantile(xs, tau)
      end
    end
  end

  describe "weighted_mean/2" do
    test "is nil when any list is empty" do
      refute Statistics.weighted_mean([], [1, 2])
      refute Statistics.weighted_mean([1, 2], [])
    end

    test "is nil when the list lengths do not match" do
      refute Statistics.weighted_mean([1, 2], [3, 4, 5])
      refute Statistics.weighted_mean([1, 2, 3], [4, 5])
    end

    property "is consistent with arithmetic mean" do
      check all(
              xs <- list_of(integer(), min_length: 1),
              w <- positive_integer()
            ) do
        weights = [w] |> Stream.cycle() |> Enum.take(length(xs))

        assert Statistics.weighted_mean(xs, weights) == Statistics.mean(xs)
      end
    end

    test "is correct for a specific dataset" do
      xs = [1, 3, 5, 6, 8, 9]
      weights = [1.0, 0.8, 1.0, 0.9, 1.0, 0.66]

      assert_in_delta(Statistics.weighted_mean(xs, weights), 5.175, 0.001)
    end
  end

  describe "rolling mean from pandas examples: " do
    test "example 1" do
      assert Statistics.rolling_mean([1, 2, 3, 4], 2) |> Enum.to_list() == [0.0, 1.5, 2.5, 3.5]
    end

    test "example 2" do
      assert Statistics.rolling_mean([1, 2, 3, 4], 3) |> Enum.to_list() == [0.0, 0.0, 2.0, 3.0]
    end

    test "example 3" do
      assert Statistics.rolling_mean([1, 2, 3, 4, 5, 6, 7, 8, 9], 4) == [
               0.0,
               0.0,
               0.0,
               2.5,
               3.5,
               4.5,
               5.5,
               6.5,
               7.5
             ]
    end
  end

  test "cumulative_sum/1" do
    assert Statistics.cumulative_sum([10, 20, 30, 50]) == [10, 30, 60, 110]
  end

  describe "hypotenuse from numpy results: " do
    test "example 1" do
      assert Statistics.hypotenuse([1, 2, 3], [1, 2, 3], 8) == [
               1.41421356,
               2.82842712,
               4.24264069
             ]
    end

    test "example 2" do
      assert Statistics.hypotenuse([57435, 53485, 87654], [87, 4321, 8765], 8) ==
               [
                 57435.06589184,
                 53659.26076643,
                 88091.13996878
               ]
    end
  end
end
