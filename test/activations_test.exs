defmodule Numerix.ActivationsTest do
  use ExUnit.Case, async: false

  import Numerix.Activations

  alias Numerix.Tensor

  @test_list [0, 0.1, 0.5, 0.9, 1.0]
  @test_vector Tensor.new(@test_list)
  @test_matrix Tensor.new([@test_list])
  @test_3dtensor Tensor.new([[@test_list]])

  describe "softmax/1" do
    test "raises an error when passed a scalar" do
      assert_raise RuntimeError, fn -> softmax(42) end
    end

    test "raises an error when passed a vector" do
      assert_raise RuntimeError, fn ->
        @test_list |> Tensor.new() |> softmax()
      end
    end

    test "is correct for a matrix" do
      assert softmax(@test_matrix).items == [
               [
                 0.1119598021340303,
                 0.12373471731203411,
                 0.18459050724175335,
                 0.2753766776533774,
                 0.30433829565880477
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert softmax(@test_3dtensor).items == [
               [
                 [
                   0.1119598021340303,
                   0.12373471731203411,
                   0.18459050724175335,
                   0.2753766776533774,
                   0.30433829565880477
                 ]
               ]
             ]
    end

    test "is correct for a complex 3D tensor" do
      tensor = Tensor.new([[@test_list, @test_list]])

      assert softmax(tensor).items == [
               [
                 [
                   0.055979901067015156,
                   0.061867358656017064,
                   0.09229525362087669,
                   0.13768833882668874,
                   0.1521691478294024
                 ],
                 [
                   0.055979901067015156,
                   0.061867358656017064,
                   0.09229525362087669,
                   0.13768833882668874,
                   0.1521691478294024
                 ]
               ]
             ]
    end
  end

  describe "sigmoid/1" do
    test "is correct for a scalar" do
      scalar = Tensor.new(1)

      assert sigmoid(scalar).items == 0.7310585786300049
    end

    test "is correct for a vector" do
      assert sigmoid(@test_vector).items == [
               0.5,
               0.52497918747894,
               0.6224593312018546,
               0.710949502625004,
               0.7310585786300049
             ]
    end

    test "is correct for a matrix" do
      assert sigmoid(@test_matrix).items == [
               [
                 0.5,
                 0.52497918747894,
                 0.6224593312018546,
                 0.710949502625004,
                 0.7310585786300049
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert sigmoid(@test_3dtensor).items == [
               [
                 [
                   0.5,
                   0.52497918747894,
                   0.6224593312018546,
                   0.710949502625004,
                   0.7310585786300049
                 ]
               ]
             ]
    end
  end

  describe "softplus/1" do
    test "is correct for a scalar" do
      assert softplus(Tensor.new(1)).items == 1.3132616875182228
    end

    test "is correct for a vector" do
      assert softplus(@test_vector).items == [
               0.6931471805599453,
               0.744396660073571,
               0.9740769841801067,
               1.2411538747320878,
               1.3132616875182228
             ]
    end

    test "is correct for a matrix" do
      assert softplus(@test_matrix).items == [
               [
                 0.6931471805599453,
                 0.744396660073571,
                 0.9740769841801067,
                 1.2411538747320878,
                 1.3132616875182228
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert softplus(@test_3dtensor).items == [
               [
                 [
                   0.6931471805599453,
                   0.744396660073571,
                   0.9740769841801067,
                   1.2411538747320878,
                   1.3132616875182228
                 ]
               ]
             ]
    end
  end

  describe "relu/1" do
    test "is correct for a scalar" do
      assert relu(Tensor.new(-42)).items == 0
    end

    test "is correct for a vector" do
      assert relu(@test_vector).items == @test_list
    end

    test "is correct for a matrix" do
      assert relu(@test_matrix).items == [@test_list]
    end

    test "is correct for a 3D tensor" do
      assert relu(@test_3dtensor).items == [[@test_list]]
    end
  end
end
