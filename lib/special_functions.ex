defmodule Numerix.SpecialFunctions do
  @moduledoc """
  Special mathematical functions.
  """

  @typedoc """
  Something that may be a float.
  """
  @type maybe_float :: float | nil

  @doc """
  Calculates the logit function (the inverse of the sigmoidal
  logistic function) for probability p (a number between 0 and 1).
  """
  @spec logit(number) :: maybe_float
  def logit(p) when p < 0 or p > 1, do: nil
  def logit(p) do
    :math.log(p / (1 - p))
  end

  @doc """
  Calculates the sigmoidal logistic function, a common "S" shape.
  """
  @spec logistic(number) :: float
  def logistic(p) do
    1 / (:math.exp(-p) + 1)
  end

end
