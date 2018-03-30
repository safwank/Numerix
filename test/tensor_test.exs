defmodule Numerix.TensorTest do
  use ExUnit.Case, async: false
  use Numerix.Tensor

  @test_list [0, 0.1, 0.5, 0.9, 1.0]
  @ones Stream.repeatedly(fn -> 1.0 end) |> Enum.take(length(@test_list))

  describe "new/1" do
    test "raises an error when passed a non-numeric scalar" do
      assert_raise RuntimeError, fn ->
        Tensor.new("foo")
      end
    end

    test "raises an error when passed a non-numeric list" do
      assert_raise RuntimeError, fn ->
        Tensor.new([["foo"]])
      end
    end

    test "creates a scalar" do
      assert Tensor.new(42) == %Tensor{items: 42, dims: 0}
    end

    test "creates a vector" do
      assert Tensor.new(@test_list) == %Tensor{items: @test_list, dims: 1}
    end

    test "creates a matrix" do
      assert Tensor.new([@test_list]) == %Tensor{items: [@test_list], dims: 2}
    end

    test "creates a 3D tensor" do
      assert Tensor.new([[@test_list]]) == %Tensor{items: [[@test_list]], dims: 3}
    end

    test "creates a complex 3D tensor" do
      assert Tensor.new([[@test_list, @test_list]]) == %Tensor{
               items: [[@test_list, @test_list]],
               dims: 3
             }
    end

    test "creates an empty 3D tensor" do
      assert Tensor.new([[[]]]) == %Tensor{items: [[[]]], dims: 3}
    end
  end

  describe "ones_like/1" do
    test "creates a vector of ones with the same shape and type as a given vector" do
      vector = Tensor.new(@test_list)

      assert ones_like(vector) == Tensor.new(@ones)
    end

    test "creates a matrix of ones with the same shape and type as a given matrix" do
      matrix = Tensor.new([@test_list, @test_list])

      assert ones_like(matrix) == Tensor.new([@ones, @ones])
    end

    test "creates a 3D tensor of ones with the same shape and type as a given 3D tensor" do
      tensor = Tensor.new([[@test_list, @test_list], [@test_list, @test_list]])

      assert ones_like(tensor) == Tensor.new([[@ones, @ones], [@ones, @ones]])
    end
  end

  describe "/" do
    test "divides one vector by another" do
      x = Tensor.new([1.0, 1.10517097, 1.64872122, 2.45960307, 2.71828175])
      y = Tensor.new([2.0, 2.10517097, 2.64872122, 3.45960307, 3.71828175])

      assert x / y ==
               Tensor.new([
                 0.5,
                 0.5249791991953984,
                 0.6224593239752125,
                 0.710949499186333,
                 0.7310585729551022
               ])
    end

    test "divides one matrix by another" do
      x = Tensor.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      y = Tensor.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      assert x / y == Tensor.new([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    end

    test "divides one 3D tensor by another" do
      x = Tensor.new([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])
      y = Tensor.new([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])

      assert x / y == Tensor.new([[[1, 1], [1, 1]], [[1, 1], [1, 1]]])
    end
  end

  describe "default arithmetic operators" do
    test "+" do
      assert 1 + 2.3 == 3.3
      # credo:disable-for-next-line
      assert +1 == 1
    end

    test "-" do
      assert round(2.3 - 1.3) == 1
      # credo:disable-for-next-line
      assert -1.0 == -1.0
    end

    test "*" do
      assert 1 * 2.3 == 2.3
    end

    test "/" do
      assert 1.0 / 4.0 == 0.25
    end
  end
end
