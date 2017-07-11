defmodule Numeric.Interpolation do
    @moduledoc """
    Implementation of Lagrange'a interpolation method
    Usage:
    ex. lagrange([{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}], 9)
    """

    @type feature_tuple :: {number, number}

    @spec lagrange([{number, number}], number) :: number
    @doc """
        function to interpolate the given data points using Lagrange's formula
        x corresponds to the new data point whose value is to be obtained
        features represents known data points
        """
    def lagrange(features, x) do
         Enum.to_list(0..length(features) - 1)
         |> Enum.map(fn(y) -> snd(take(features, y)) * l(y, features, x) end)
         |> List.foldr(0, fn(y, acc) -> y + acc end)
    end

    @spec l(number, [{number, number}], number) :: number
    def l(j, features, x) do
        Enum.filter(Enum.to_list(0..length(features) - 1), fn(i) -> i != j end)
        |> Enum.map(fn(y) -> ((x - fst(take(features, y))) / (fst(take(features, j)) - fst(take(features, y)))) end)
        |> List.foldr(1, fn(x, acc) -> x * acc end)
    end

    @spec take([number], number) :: feature_tuple
    def take([h|t], n) do
        case n do
            0 -> h
            _ -> take(t, n - 1)
        end
    end

    @spec fst(feature_tuple) :: number
    def fst({x, _}) do x end

    @spec snd(tuple) :: number
    def snd({_, x}) do x end

end
