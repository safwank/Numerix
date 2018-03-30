defmodule Numerix.Activations do
  @moduledoc """
  Activation functions for neural networks.
  """

  use Numerix.Tensor

  def softmax(x = %Tensor{dims: dims}) when dims > 1 do
    m = max_in(x)
    e = exp(x - m)
    s = sum(e)
    e / s
  end

  def softmax(_) do
    raise "Tensor has to be at least 2D"
  end

  def softplus(x) do
    log(ones_like(x) + exp(x))
  end

  def sigmoid(x = %Tensor{dims: 0}) do
    1 / (1 + exp(-x))
  end

  def sigmoid(x = %Tensor{dims: dims}) when dims > 0 do
    z = exp(x)
    z / (1 + z)
  end

  def relu(x) do
    max_between(0, x)
  end
end
