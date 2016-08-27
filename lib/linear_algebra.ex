defmodule Numerix.LinearAlgebra do
  @moduledoc """
  Linear algebra functions used for matrix factorization and transformation.
  """

  @doc """
  The sum of the products of two vectors.
  """
  def dot_product(vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Stream.map(fn {x, y} -> x * y end)
    |> Enum.sum
  end

end
