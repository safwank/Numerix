defmodule Numerix.ActivationsTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Numerix.Activations
  import PropertyHelper
  import ListHelper

  alias Numerix.Tensor

  @test_list [0, 0.1, 0.5, 0.9, 1.0]
  @test_vector Tensor.new(@test_list)
  @test_matrix Tensor.new([@test_list])
  @test_3dtensor Tensor.new([[@test_list]])

  describe "softmax/1" do
    property "is correct for a tensor of two or more dimensions" do
      check all test_case <-
                  StreamData.member_of([
                    %{
                      input: @test_matrix,
                      output: [
                        [
                          0.1119598021340303,
                          0.12373471731203411,
                          0.18459050724175335,
                          0.2753766776533774,
                          0.30433829565880477
                        ]
                      ]
                    },
                    %{
                      input: @test_3dtensor,
                      output: [
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
                    },
                    %{
                      input: Tensor.new([[@test_list, @test_list]]),
                      output: [
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
                    }
                  ]) do
        assert softmax(test_case.input).items == test_case.output
      end
    end

    property "is between 0 and 1" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        softmax(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x |> between?(0, 1)
        end)
      end
    end
  end

  describe "sigmoid/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(1), output: 0.7310585786300049},
                    %{
                      input: @test_vector,
                      output: [
                        0.5,
                        0.52497918747894,
                        0.6224593312018546,
                        0.710949502625004,
                        0.7310585786300049
                      ]
                    },
                    %{
                      input: @test_matrix,
                      output: [
                        [
                          0.5,
                          0.52497918747894,
                          0.6224593312018546,
                          0.710949502625004,
                          0.7310585786300049
                        ]
                      ]
                    },
                    %{
                      input: @test_3dtensor,
                      output: [
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
                    }
                  ]) do
        assert sigmoid(test_case.input).items == test_case.output
      end
    end

    property "is between 0 and 1" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        sigmoid(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x |> between?(0, 1)
        end)
      end
    end
  end

  describe "softplus/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(1), output: 1.3132616875182228},
                    %{
                      input: @test_vector,
                      output: [
                        0.6931471805599453,
                        0.744396660073571,
                        0.9740769841801067,
                        1.2411538747320878,
                        1.3132616875182228
                      ]
                    },
                    %{
                      input: @test_matrix,
                      output: [
                        [
                          0.6931471805599453,
                          0.744396660073571,
                          0.9740769841801067,
                          1.2411538747320878,
                          1.3132616875182228
                        ]
                      ]
                    },
                    %{
                      input: @test_3dtensor,
                      output: [
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
                    }
                  ]) do
        assert softplus(test_case.input).items == test_case.output
      end
    end

    property "is greater than or equal to 0" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        softplus(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x >= 0
        end)
      end
    end
  end

  describe "softsign/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(1.0), output: 0.5},
                    %{
                      input: @test_vector,
                      output: [
                        0.0,
                        0.09090909090909091,
                        0.3333333333333333,
                        0.4736842105263158,
                        0.5
                      ]
                    },
                    %{
                      input: @test_matrix,
                      output: [
                        [
                          0.0,
                          0.09090909090909091,
                          0.3333333333333333,
                          0.4736842105263158,
                          0.5
                        ]
                      ]
                    },
                    %{
                      input: @test_3dtensor,
                      output: [
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
                    }
                  ]) do
        assert softsign(test_case.input).items == test_case.output
      end
    end

    property "is between -1 and 1" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        softsign(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x |> between?(-1, 1)
        end)
      end
    end
  end

  describe "relu/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(-42), output: Tensor.new(0)},
                    %{input: @test_vector, output: @test_vector},
                    %{input: @test_matrix, output: @test_matrix},
                    %{input: @test_3dtensor, output: @test_3dtensor}
                  ]) do
        assert relu(test_case.input) == test_case.output
      end
    end

    property "is greater than or equal to 0" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        relu(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x >= 0
        end)
      end
    end
  end

  describe "leaky_relu/2" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: 2.0, output: 2.0},
                    %{input: [-2, -1, 0, 1, 2], output: [-0.2, -0.1, 0, 1, 2]},
                    %{input: [[-2, -1, 0, 1, 2]], output: [[-0.2, -0.1, 0, 1, 2]]},
                    %{input: [[[-2, -1, 0, 1, 2]]], output: [[[-0.2, -0.1, 0, 1, 2]]]}
                  ]) do
        tensor = Tensor.new(test_case.input)
        assert leaky_relu(tensor, 0.1).items == test_case.output
      end
    end
  end

  describe "elu/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(-42.0), output: Tensor.new(-1.0)},
                    %{input: @test_vector, output: @test_vector},
                    %{
                      input: Tensor.new([-1, -2]),
                      output: Tensor.new([-0.6321205588285577, -0.8646647167633873])
                    },
                    %{input: @test_matrix, output: @test_matrix},
                    %{input: @test_3dtensor, output: @test_3dtensor}
                  ]) do
        assert elu(test_case.input) == test_case.output
      end
    end
  end

  describe "selu/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(-42.0), output: Tensor.new(-1.7580993408473766)},
                    %{
                      input: @test_vector,
                      output:
                        Tensor.new([
                          0.0,
                          0.10507009873554805,
                          0.5253504936777402,
                          0.9456308886199324,
                          1.0507009873554805
                        ])
                    },
                    %{
                      input: Tensor.new([-1, -2]),
                      output: Tensor.new([-1.1113307378125625, -1.520166468595695])
                    },
                    %{
                      input: @test_matrix,
                      output:
                        Tensor.new([
                          [
                            0.0,
                            0.10507009873554805,
                            0.5253504936777402,
                            0.9456308886199324,
                            1.0507009873554805
                          ]
                        ])
                    },
                    %{
                      input: @test_3dtensor,
                      output:
                        Tensor.new([
                          [
                            [
                              0.0,
                              0.10507009873554805,
                              0.5253504936777402,
                              0.9456308886199324,
                              1.0507009873554805
                            ]
                          ]
                        ])
                    }
                  ]) do
        assert selu(test_case.input) == test_case.output
      end
    end
  end

  describe "tanh/1" do
    property "is correct for a tensor of any dimension" do
      check all test_case <-
                  StreamData.member_of([
                    %{input: Tensor.new(1), output: 0.76159415595576485},
                    %{
                      input: @test_vector,
                      output: [
                        0.0,
                        0.09966799462495582,
                        0.46211715726000974,
                        0.7162978701990245,
                        0.7615941559557649
                      ]
                    },
                    %{
                      input: @test_matrix,
                      output: [
                        [
                          0.0,
                          0.09966799462495582,
                          0.46211715726000974,
                          0.7162978701990245,
                          0.7615941559557649
                        ]
                      ]
                    },
                    %{
                      input: @test_3dtensor,
                      output: [
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
                    }
                  ]) do
        assert tanh(test_case.input).items == test_case.output
      end
    end

    property "is between -1 and 1" do
      check all values <- matrix_of(StreamData.float(), 5) do
        matrix = Tensor.new(values)

        tanh(matrix).items
        |> List.flatten()
        |> Enum.each(fn x ->
          assert x |> between?(-1, 1)
        end)
      end
    end
  end
end
