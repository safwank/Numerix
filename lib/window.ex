defmodule Numerix.Window do
  @moduledoc """
  Functions used to smoothly bring a sampled signal down
  to zero at the edges of the sampled region.
  https://en.wikipedia.org/wiki/Window_function  
  """

  @doc """
  A bell curve function calculated based on the
  width (distance) and sigma (standard deviation).
  """
  @spec gaussian(number, number) :: float
  def gaussian(width, sigma \\ 1.0)
  def gaussian(_width, sigma) when sigma == 0, do: 0.0

  def gaussian(width, sigma) do
    :math.exp(-0.5 * :math.pow(width / sigma, 2))
  end
end
