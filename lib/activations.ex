defmodule Numerix.Activations do
  @moduledoc """
  Activation functions for neural networks.
  """

  use Numerix.Tensor

  def softmax(x = %Tensor{dims: dims}) when dims > 1 do
    m = max(x)
    e = exp(x - m)
    s = sum(e)
    e / s
  end

  def softplus(x) do
    log(1 + exp(x))
  end

  def sigmoid(x = %Tensor{dims: 0}) do
    1 / (1 + exp(-x))
  end

  def sigmoid(x = %Tensor{dims: dims}) when dims > 0 do
    z = exp(x)
    z / (1 + z)
  end

  def relu(x) do
    max(0, x)
  end

  def leaky_relu(x, alpha) when alpha != 0 do
    max(alpha * x, x)
  end

  def elu(x, alpha \\ 1.0) do
    t_apply(
      fn
        i when i >= 0 -> i
        i -> alpha * (:math.exp(i) - 1)
      end,
      x
    )
  end

  def selu(x) do
    alpha = 1.6732632423543772848170429916717
    scale = 1.0507009873554804934193349852946
    scale * elu(x, alpha)
  end

  def tanh(x) do
    Tensor.tanh(x)
  end
end
