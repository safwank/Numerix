defmodule Numerix.CorrelationTest do
  use ExUnit.Case, async: false
  use ExCheck
  import ListHelper

  alias Numerix.Correlation

  test :pearson_is_nil_when_any_vector_is_empty do
    refute Correlation.pearson([], [1])
    refute Correlation.pearson([2], [])
    refute Correlation.pearson([], [])
  end

  test :pearson_is_nil_when_the_vectors_are_not_the_same_size do
    refute Correlation.pearson([1, 2, 3], [4, 5, 6, 7])
  end

  property :pearson_correlation_is_zero_when_the_vectors_are_equal_but_variance_is_zero do
    for_all {x, len} in {int(), pos_integer()} do
      xs = [x] |> Stream.cycle() |> Enum.take(len)

      Correlation.pearson(xs, xs) == 0.0
    end
  end

  property :pearson_correlation_is_one_when_the_vectors_are_equal_and_variance_is_not_zero do
    for_all xs in non_empty(list(int())) do
      implies length(xs) > 1 and xs == Enum.uniq(xs) do
        Correlation.pearson(xs, xs) == 1.0
      end
    end
  end

  property :pearson_correlation_is_between_minus_1_and_1 do
    for_all {xs, ys} in {non_empty(list(int())), non_empty(list(int()))} do
      {xs, ys} = equalize_length(xs, ys)

      Correlation.pearson(xs, ys) |> between?(-1, 1)
    end
  end

  test :pearson_correlation_is_correct_for_a_specific_dataset do
    vector1 = DataHelper.read("Lew") |> Map.get(:data) |> Enum.take(200)
    vector2 = DataHelper.read("Lottery") |> Map.get(:data) |> Enum.take(200)

    assert Correlation.pearson(vector1, vector2) == -0.02947086158072648
  end

  test :weighted_pearson_is_nil_when_any_vector_is_empty do
    refute Correlation.pearson([], [1], [2])
    refute Correlation.pearson([1], [], [2])
    refute Correlation.pearson([1], [2], [])
    refute Correlation.pearson([], [], [])
  end

  test :weighted_pearson_correlation_with_constant_weights_is_consistent_with_unweighted_correlation do
    vector1 = DataHelper.read("Lew") |> Map.get(:data) |> Enum.take(200)
    vector2 = DataHelper.read("Lottery") |> Map.get(:data) |> Enum.take(200)
    weights = [2.0] |> Stream.cycle() |> Enum.take(vector1 |> length)

    weighted_correlation = Correlation.pearson(vector1, vector2, weights)
    unweighted_correlation = Correlation.pearson(vector1, vector2)

    assert_in_delta(weighted_correlation, unweighted_correlation, 0.0000000001)
  end
end
