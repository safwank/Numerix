defmodule Numerix.Optimization do
  @moduledoc """
  Optimization algorithms to select the best element from a set of possible solutions.
  """

  @default_opts [population_size: 50, mutation_prob: 0.2, elite_fraction: 0.2, iterations: 50]

  @doc """
  Genetic algorithm to find the solution with the lowest cost where `domain` is
  a set of all possible values (i.e. ranges) in the solution and `cost_fun` determines
  how optimal each solution is.

  Example

    iex> domain = [0..9] |> Stream.cycle |> Enum.take(10)
    iex> cost_fun = fn(x) -> Enum.sum(x) end
    iex> Numerix.Optimize.genetic(domain, cost_fun)
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

  ## Options
    * `:population_size` - the size of population to draw the solutions from
    * `:mutation_prob` - the minimum probability that decides if mutation should occur
    * `:elite_fraction` - the percentage of population that will form the elite group in each generation
    * `:iterations` - the maximum number of generations to evolve the solutions
  """
  @spec genetic([Range.t], (([integer]) -> number), Keyword.t) :: [integer]
  @lint [{Credo.Check.Refactor.ABCSize, false}, {Credo.Check.Refactor.Nesting, false}]
  def genetic(domain, cost_fun, opts \\ []) do
    merged_opts = @default_opts |> Keyword.merge(opts)
    top_elite = round(merged_opts[:elite_fraction] * merged_opts[:population_size])

    population = Stream.repeatedly(fn ->
      domain |> Enum.map(fn range -> Enum.random(range) end)
    end)
    |> Enum.take(merged_opts[:population_size])

    evolve = fn
      ([best | _rest], 0, _fun) ->
        best
      (pop, iteration, fun) ->
        Stream.repeatedly(fn ->
          if :rand.uniform < merged_opts[:mutation_prob] do
            elite_idx = 0..top_elite |> Enum.random
            pop |> Enum.at(elite_idx) |> mutate(domain)
          else
            elite_idx1 = 0..top_elite |> Enum.random
            elite_idx2 = 0..top_elite |> Enum.random
            Enum.at(pop, elite_idx1) |> crossover(Enum.at(pop, elite_idx2))
          end
        end)
        |> Stream.take(merged_opts[:population_size])
        |> Stream.concat(pop |> Enum.take(top_elite))
        |> Stream.map(& {cost_fun.(&1), &1})
        |> Enum.sort
        |> Enum.map(fn {_cost, solution} -> solution end)
        |> fun.(iteration - 1, fun)
    end

    evolve.(population, merged_opts[:iterations], evolve)
  end

  defp crossover(vector1, vector2) do
    idx = vector1 |> random_index

    vector1
    |> Enum.take(idx)
    |> Enum.concat(vector2 |> Enum.drop(idx))
  end

  defp mutate(vector, domain) do
    idx = vector |> random_index

    vector
    |> Stream.with_index
    |> Stream.map(& do_mutate(&1, idx, domain))
    |> Enum.to_list
  end

  defp do_mutate({x, i}, target_idx, domain) when i == target_idx do
    {min, max} = domain
      |> Enum.at(i)
      |> Enum.min_max

    cond do
      :rand.uniform < 0.5 and x > min ->
        x - 1
      x < max ->
        x + 1
      true ->
        x
    end
  end
  defp do_mutate({x, _i}, _target_idx, _domain), do: x

  defp random_index(vector) do
    max = Enum.count(vector) - 1
    0..max |> Enum.random
  end
end
