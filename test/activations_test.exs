defmodule Numerix.ActivationsTest do
  use ExUnit.Case, async: false

  import Numerix.Activations

  alias Numerix.Tensor

  @test_list [0, 0.1, 0.5, 0.9, 1.0]
  @test_vector Tensor.new(@test_list)
  @test_matrix Tensor.new([@test_list])
  @test_3dtensor Tensor.new([[@test_list]])

  describe "softmax/1" do
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

  describe "softsign/1" do
    test "is correct for a scalar" do
      assert softsign(Tensor.new(1.0)).items == 0.5
    end

    test "is correct for a vector" do
      assert softsign(@test_vector).items == [
               0.0,
               0.09090909090909091,
               0.3333333333333333,
               0.4736842105263158,
               0.5
             ]
    end

    test "is correct for a matrix" do
      assert softsign(@test_matrix).items == [
               [
                 0.0,
                 0.09090909090909091,
                 0.3333333333333333,
                 0.4736842105263158,
                 0.5
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert softsign(@test_3dtensor).items == [
               [
                 [
                   0.0,
                   0.09090909090909091,
                   0.3333333333333333,
                   0.4736842105263158,
                   0.5
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

  describe "leaky_relu/2" do
    test "is correct for a scalar" do
      matrix = Tensor.new(2.0)

      assert leaky_relu(matrix, 0.1).items == 2.0
    end

    test "is correct for a vector" do
      vector = Tensor.new([-2, -1, 0, 1, 2])

      assert leaky_relu(vector, 0.1).items == [-0.2, -0.1, 0, 1, 2]
    end

    test "is correct for a matrix" do
      matrix = Tensor.new([[-2, -1, 0, 1, 2]])

      assert leaky_relu(matrix, 0.1).items == [[-0.2, -0.1, 0, 1, 2]]
    end

    test "is correct for a 3D tensor" do
      tensor = Tensor.new([[[-2, -1, 0, 1, 2]]])

      assert leaky_relu(tensor, 0.1).items == [[[-0.2, -0.1, 0, 1, 2]]]
    end
  end

  describe "elu/1" do
    test "is correct for a scalar" do
      assert elu(Tensor.new(-42.0)).items == -1.0
    end

    test "is correct for a vector" do
      assert elu(@test_vector).items == @test_list

      negative_values = Tensor.new([-1, -2])
      assert elu(negative_values).items == [-0.6321205588285577, -0.8646647167633873]
    end

    test "is correct for a matrix" do
      assert elu(@test_matrix).items == [@test_list]
    end

    test "is correct for a 3D tensor" do
      assert elu(@test_3dtensor).items == [[@test_list]]
    end
  end

  describe "selu/1" do
    test "is correct for a scalar" do
      assert selu(Tensor.new(-42.0)).items == -1.7580993408473766
    end

    test "is correct for a vector" do
      assert selu(@test_vector).items == [
               0.0,
               0.10507009873554805,
               0.5253504936777402,
               0.9456308886199324,
               1.0507009873554805
             ]

      negative_values = Tensor.new([-1, -2])
      assert selu(negative_values).items == [-1.1113307378125625, -1.520166468595695]
    end

    test "is correct for a matrix" do
      assert selu(@test_matrix).items == [
               [
                 0.0,
                 0.10507009873554805,
                 0.5253504936777402,
                 0.9456308886199324,
                 1.0507009873554805
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert selu(@test_3dtensor).items == [
               [
                 [
                   0.0,
                   0.10507009873554805,
                   0.5253504936777402,
                   0.9456308886199324,
                   1.0507009873554805
                 ]
               ]
             ]
    end
  end

  describe "tanh/1" do
    test "is correct for a scalar" do
      assert tanh(Tensor.new(1)).items == 0.76159415595576485
    end

    test "is correct for a vector" do
      assert tanh(@test_vector).items == [
               0.0,
               0.09966799462495582,
               0.46211715726000974,
               0.7162978701990245,
               0.7615941559557649
             ]
    end

    test "is correct for a matrix" do
      assert tanh(@test_matrix).items == [
               [
                 0.0,
                 0.09966799462495582,
                 0.46211715726000974,
                 0.7162978701990245,
                 0.7615941559557649
               ]
             ]
    end

    test "is correct for a 3D tensor" do
      assert tanh(@test_3dtensor).items == [
               [
                 [
                   0.0,
                   0.09966799462495582,
                   0.46211715726000974,
                   0.7162978701990245,
                   0.7615941559557649
                 ]
               ]
             ]
    end
  end
end
