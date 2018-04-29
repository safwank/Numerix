defmodule Numerix.LinearAlgebra do
  @moduledoc """
  Linear algebra functions used for vector operations,
  matrix factorization and matrix transformation.
  """

  use Numerix.Tensor

  alias Numerix.{Common, Math}

  @doc """
  The sum of the products of two vectors.
  """
  @spec dot(Common.vector(), Common.vector()) :: Common.maybe_float()
  def dot(x = %Tensor{}, y = %Tensor{}) do
    sum(x * y)
  end

  def dot(vector1, vector2) do
    x = Tensor.new(vector1)
    y = Tensor.new(vector2)
    dot(x, y)
  end

  @doc """
  The L1 norm of a vector, also known as Manhattan norm.
  """
  @spec l1_norm(Common.maybe_vector()) :: Common.maybe_float()
  def l1_norm(vector) do
    norm(1, vector)
  end

  @doc """
  The L2 norm of a vector, also known as Euclidean norm.
  """
  @spec l2_norm(Common.maybe_vector()) :: Common.maybe_float()
  def l2_norm(vector) do
    norm(2, vector)
  end

  @doc """
  The p-norm of a vector.
  """
  @spec norm(integer, Common.maybe_vector()) :: Common.maybe_float()
  def norm(_p, nil), do: nil

  def norm(p, x = %Tensor{}) do
    s = sum(pow(abs(x), p))
    Math.nth_root(s, p)
  end

  def norm(p, vector) do
    x = Tensor.new(vector)
    norm(p, x)
  end
end
