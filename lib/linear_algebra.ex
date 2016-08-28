defmodule Numerix.LinearAlgebra do
  @moduledoc """
  Linear algebra functions used for vector operations,
  matrix factorization and matrix transformation.
  """

  alias Numerix.{Common, Math}

  @doc """
  The sum of the products of two vectors.
  """
  @spec dot_product([number], [number]) :: Common.maybe_float
  def dot_product(vector1, vector2) do
    vector1
    |> multiply(vector2)
    |> Enum.sum
  end

  @doc """
  The L1 norm of a vector, also known as Manhattan norm.
  """
  @spec l1_norm(Common.maybe_vector) :: Common.maybe_float
  def l1_norm(vector) do
    1 |> norm(vector)
  end

  @doc """
  The L2 norm of a vector, also known as Euclidean norm.
  """
  @spec l2_norm(Common.maybe_vector) :: Common.maybe_float
  def l2_norm(vector) do
    2 |> norm(vector)
  end

  @doc """
  The p-norm of a vector.
  """
  @spec norm(integer, Common.maybe_vector) :: Common.maybe_float
  def norm(_p, nil), do: nil
  def norm(p, vector) do
    vector
    |> Stream.map(fn x ->
      abs(x) |> :math.pow(p)
    end)
    |> Enum.sum
    |> Math.nth_root(p)
  end

  @doc """
  Subtracts a vector from another.
  Returns a stream of the differences.
  """
  @spec subtract([number], [number]) :: Common.maybe_vector
  def subtract(vector1, vector2) do
    fn(x, y) -> x - y end
    |> vec_apply(vector1, vector2)
  end

  @doc """
  Multiplies a vector with another.
  Returns a stream of the products.
  """
  @spec multiply([number], [number]) :: Common.maybe_vector
  def multiply(vector1, vector2) do
    fn(x, y) -> x * y end
    |> vec_apply(vector1, vector2)
  end

  defp vec_apply(_fun, [], _), do: nil
  defp vec_apply(_fun, _, []), do: nil
  defp vec_apply(fun, vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Stream.map(fn {x, y} -> fun.(x, y) end)
  end
end
