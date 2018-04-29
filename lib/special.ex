defmodule Numerix.Special do
  @moduledoc """
  Special mathematical functions that would make Euler proud.
  """

  alias Numerix.Common

  @doc """
  Calculates the logit function (the inverse of the sigmoidal
  logistic function) for probability p (a number between 0 and 1).
  """
  @spec logit(float) :: Common.extended_number() | nil
  def logit(0.0), do: :negative_infinity
  def logit(1.0), do: :infinity
  def logit(p) when p < 0 or p > 1, do: nil

  def logit(p) do
    :math.log(p / (1 - p))
  end

  @doc """
  Calculates the sigmoidal logistic function, a common "S" shape.
  It is the inverse of the natural logit function and so can be
  used to convert the logarithm of odds into a probability.
  """
  @spec logistic(Common.extended_number()) :: float
  def logistic(:negative_infinity), do: 0.0
  def logistic(:infinity), do: 1.0

  def logistic(p) do
    1 / (:math.exp(-p) + 1)
  end
end
