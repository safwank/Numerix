defmodule Numerix.LinearRegressionTest do
  use ExUnit.Case, async: false

  import Numerix.LinearRegression

  test "least square fit is nil when any vector is empty" do
    refute fit([], [1, 2, 3])
    refute fit([1, 2, 3], [])
  end

  test "least square fit is nil when the vectors aren't the same size" do
    refute fit([1, 2, 3], [4, 5])
  end

  test "least squares fit is correct for a specific example" do
    {intercept, slope} = fit([1.3, 2.1, 3.7, 4.2], [2.2, 5.8, 10.2, 11.8])

    assert_in_delta(intercept, -1.52256, 0.00001)
    assert_in_delta(slope, 3.19383, 0.00001)
  end
end
