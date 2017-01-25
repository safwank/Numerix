defmodule Numerix.Kernel do
  @moduledoc """
  Functions used as kernel methods for classification, regression and clustering.
  """

  import Numerix.LinearAlgebra

  alias Numerix.Common

  @doc """
  Radial basis function used to approximate given functions.
  It is particularly useful for time series prediction and
  control of nonlinear systems. It can also be seen as a
  simple single-layer type of artificial neural network where
  the function acts as the activation function for the network.
  """
  @spec rbf([number], [number], integer) :: Common.maybe_float
  def rbf(vector1, vector2, gamma \\ 10) do
    vector1
    |> subtract(vector2)
    |> Flow.from_enumerable
    |> Flow.map(&:math.pow(&1, 2))
    |> Enum.sum
    |> to_sum(gamma)
  end

  defp to_sum(vec_length, gamma) do
    :math.exp(-gamma * vec_length)
  end

end
