defmodule Numerix.Kernel do
  @moduledoc """
  Functions used as kernel methods for classification, regression and clustering.
  """

  use Numerix.Tensor

  alias Numerix.Common

  @doc """
  Radial basis function used to approximate given functions.
  It is particularly useful for time series prediction and
  control of nonlinear systems. It can also be seen as a
  simple single-layer type of artificial neural network where
  the function acts as the activation function for the network.
  """
  @spec rbf(Common.vector(), Common.vector(), integer) :: Common.maybe_float()
  def rbf(x, y, gamma \\ 10)

  def rbf(x = %Tensor{}, y = %Tensor{}, gamma) do
    p = pow(x - y, 2)
    len = sum(p)
    :math.exp(-gamma * len)
  end

  def rbf(vector1, vector2, gamma) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    rbf(x, y, gamma)
  end
end
