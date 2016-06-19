defmodule Numerix.DistanceTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.{Distance, Correlation}

  test :pearson_is_nil_when_any_vector_is_empty do
    refute Distance.pearson([],[1])
    refute Distance.pearson([2],[])
    refute Distance.pearson([],[])
  end

  property :pearson_distance_is_the_inverse_of_its_correlation do
    for_all {xs, ys} in {non_empty(list(int)), non_empty(list(int))} do
      {xs, ys} = ListHelper.equalize_length(xs, ys)
      Distance.pearson(xs, ys) == 1.0 - Correlation.pearson(xs, ys)
    end
  end

  property :pearson_distance_is_between_0_and_2 do
    for_all {xs, ys} in {non_empty(list(int)), non_empty(list(int))} do
      {xs, ys} = ListHelper.equalize_length(xs, ys)
      distance = Distance.pearson(xs, ys)
      distance >= 0 and distance <= 2
    end
  end

  test :minkowski_is_nil_when_any_vector_is_empty do
    refute Distance.minkowski([],[1])
    refute Distance.minkowski([2],[])
    refute Distance.minkowski([],[])
  end

  property :minkowski_distance_is_zero_when_the_vectors_are_equal do
    for_all xs in non_empty(list(number)) do
      Distance.minkowski(xs, xs) == 0
    end
  end

  test :minkowski_distance_is_correct_for_a_specific_dataset_when_using_the_default_lambda do
    vector1 = [1, 3, 5, 6, 8, 9]
    vector2 = [2, 5, 6, 6, 7, 7]

    assert Distance.minkowski(vector1, vector2) == 2.6684016487219897
  end

  test :minkowski_distance_is_correct_for_a_specific_dataset_when_using_a_different_lambda do
    vector1 = [1, 3, 5, 6, 8, 9]
    vector2 = [2, 5, 6, 6, 7, 7]
    lambda = 5

    assert Distance.minkowski(vector1, vector2, lambda) == 2.3185419629968713
  end

  test :euclidean_is_nil_when_any_vector_is_empty do
    refute Distance.euclidean([],[1])
    refute Distance.euclidean([2],[])
    refute Distance.euclidean([],[])
  end

  property :euclidean_distance_is_zero_when_the_vectors_are_equal do
    for_all xs in non_empty(list(number)) do
      Distance.euclidean(xs, xs) == 0
    end
  end

  test :euclidean_distance_is_correct_for_a_specific_dataset do
    vector1 = [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
    vector2 = [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

    assert Distance.euclidean(vector1, vector2) == 4.2426406871196605
  end

  test :manhattan_is_nil_when_any_vector_is_empty do
    refute Distance.manhattan([],[1])
    refute Distance.manhattan([2],[])
    refute Distance.manhattan([],[])
  end

  property :manhattan_distance_is_zero_when_the_vectors_are_equal do
    for_all xs in non_empty(list(number)) do
      Distance.manhattan(xs, xs) == 0
    end
  end

  test :manhattan_distance_is_correct_for_a_specific_dataset do
    vector1 = [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
    vector2 = [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

    assert Distance.manhattan(vector1, vector2) == 12
  end

  test :jaccard_is_0_when_both_vectors_are_empty do
    assert Distance.jaccard([], []) == 0.0
  end

  test :jaccard_is_nil_when_any_vector_is_empty do
    refute Distance.jaccard([],[1])
    refute Distance.jaccard([2],[])
  end

  test :jaccard_is_correct_for_specific_examples do
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

  property :jaccard_is_between_0_and_1 do
    for_all {xs, ys} in {non_empty(list(non_neg_integer)), non_empty(list(non_neg_integer))} do
      distance = Distance.jaccard(xs, ys)

      distance >= 0 and distance <= 1
    end
  end

end
