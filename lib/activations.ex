defmodule Numerix.Activations do
  @moduledoc """
  Activation functions for neural networks.
  """

  use Numerix.Tensor

  @doc """
  Computes the softmax of a tensor.
  """
  @spec softmax(%Tensor{}) :: %Tensor{}
  def softmax(x = %Tensor{dims: dims}) when dims > 1 do
    m = max(x)
    e = exp(x - m)
    s = sum(e)
    e / s
  end

  @doc """
  Computes the softplus of a tensor.
  """
  @spec softplus(%Tensor{}) :: %Tensor{}
  def softplus(x) do
    log(1 + exp(x))
  end

  @doc """
  Computes the softsign of a tensor.
  """
  @spec softsign(%Tensor{}) :: %Tensor{}
  def softsign(x) do
    x / (1 + abs(x))
  end

  @doc """
  Computes the element-wise sigmoid of a tensor.
  """
  @spec sigmoid(%Tensor{}) :: %Tensor{}
  def sigmoid(x = %Tensor{dims: 0}) do
    1 / (1 + exp(-x))
  end

  def sigmoid(x = %Tensor{dims: dims}) when dims > 0 do
    z = exp(x)
    z / (1 + z)
  end

  @doc """
  Computes the rectified linear unit of a tensor.
  """
  @spec relu(%Tensor{}) :: %Tensor{}
  def relu(x) do
    max(0, x)
  end

  @doc """
  Computes the leaky rectified linear unit of a tensor.
  """
  @spec leaky_relu(%Tensor{}, number) :: %Tensor{}
  def leaky_relu(x, alpha) when alpha != 0 do
    max(alpha * x, x)
  end

  @doc """
  Computes the exponential linear unit of a tensor.
  """
  @spec elu(%Tensor{}, number) :: %Tensor{}
  def elu(x, alpha \\ 1.0) do
    t_apply(
      fn
        i when i >= 0 -> i
        i -> alpha * (:math.exp(i) - 1)
      end,
      x
    )
  end

  @doc """
  Computes the scaled exponential linear unit of a tensor.
  """
  @spec selu(%Tensor{}) :: %Tensor{}
  def selu(x) do
    alpha = 1.6732632423543772848170429916717
    scale = 1.0507009873554804934193349852946
    scale * elu(x, alpha)
  end

  @doc """
  Computes the element-wise hyperbolic tangent of a tensor.
  """
  @spec tanh(%Tensor{}) :: %Tensor{}
  def tanh(x) do
    Tensor.tanh(x)
  end
end
