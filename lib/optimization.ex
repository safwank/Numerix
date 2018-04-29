defmodule Numerix.Optimization do
  @moduledoc """
  Optimization algorithms to select the best element from a set of possible solutions.
  """

  @default_opts [population_size: 50, mutation_prob: 0.2, elite_fraction: 0.2, iterations: 100]

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
  @spec genetic([Range.t()], ([integer] -> number), Keyword.t()) :: [integer]
  @lint [{Credo.Check.Refactor.Nesting, false}]
  def genetic(domain, cost_fun, opts \\ []) do
    merged_opts = Keyword.merge(@default_opts, opts)
    top_elite = round(merged_opts[:elite_fraction] * merged_opts[:population_size])
    population = init_population(domain, merged_opts[:population_size])

    evolve = fn
      [best | _rest], 0, _fun ->
        best

      pop, iteration, fun ->
        Stream.repeatedly(fn ->
          if :rand.uniform() < merged_opts[:mutation_prob] do
            pop |> mutate(domain, top_elite)
          else
            pop |> crossover(top_elite)
          end
        end)
        |> Stream.take(merged_opts[:population_size])
        |> Stream.concat(pop |> Enum.take(top_elite))
        |> Stream.map(&{cost_fun.(&1), &1})
        |> Enum.sort()
        |> Enum.map(fn {_cost, solution} -> solution end)
        |> fun.(iteration - 1, fun)
    end

    evolve.(population, merged_opts[:iterations], evolve)
  end

  defp init_population(domain, size) do
    Stream.repeatedly(fn -> Enum.map(domain, &Enum.random/1) end)
    |> Enum.take(size)
  end

  defp crossover(population, top_elite) do
    vector1 = population |> Enum.at(Enum.random(0..top_elite))
    vector2 = population |> Enum.at(Enum.random(0..top_elite))
    idx = random_index(vector1)

    vector1
    |> Enum.take(idx)
    |> Enum.concat(vector2 |> Enum.drop(idx))
  end

  defp mutate(population, domain, top_elite) do
    elite_idx = Enum.random(0..top_elite)
    target_vector = population |> Enum.at(elite_idx)
    target_idx = random_index(target_vector)

    target_vector
    |> Stream.with_index()
    |> Stream.map(&do_mutate(&1, target_idx, domain))
    |> Enum.to_list()
  end

  defp do_mutate({x, i}, target_idx, domain) when i == target_idx do
    {min, max} = domain |> Enum.at(i) |> Enum.min_max()

    cond do
      :rand.uniform() < 0.5 and x > min ->
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
    Enum.random(0..max)
  end
end
