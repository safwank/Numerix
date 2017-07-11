defmodule Interpolation do
    @moduledoc """
    Implementation of Lagrange'a interpolation method
    Usage:
    ex. lagrange([{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}], 9)
    """

    def lagrange(features, x) do
        @doc """ 
        function to interpolate the given data points using Lagrange's formula
        x corresponds to the new data point whose value is to be obtained
        features represents known data points 
        """
         Enum.to_list(0..length(features) -1)
         |> Enum.map(fn(y) -> snd(take(features, y))* l(y, features, x) end)
         |> List.foldr(0, fn(y, acc) -> y+acc end)
    end

    def l(j, features, x) do
        Enum.filter(Enum.to_list(0..length(features)-1), fn(i) -> i != j end)
        |> Enum.map(fn(y) -> ((x - fst(take(features, y))) / (fst(take(features, j))- fst(take(features, y)))) end)
        |> List.foldr(1, fn(x, acc) -> x*acc end)
    end

    def take([h|t], n) do
        case n do
            0 -> h
            _ -> take(t, n-1)
        end
    end

    def fst({x, _}) do x end
    def snd({_, x}) do x end

end
