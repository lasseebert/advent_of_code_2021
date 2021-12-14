defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 10)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 40)
  end

  defp solve(input, steps) do
    {template, rules} = parse(input)

    template
    |> count_pairs()
    |> stream(rules)
    |> Enum.at(steps)
    |> pair_counts_to_element_counts(template)
    |> Map.values()
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  defp count_pairs(polymer) do
    polymer
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.frequencies()
  end

  defp pair_counts_to_element_counts(pair_counts, template) do
    first = List.first(template)
    last = List.last(template)

    pair_counts
    |> Enum.flat_map(fn {{a, b}, count} -> [{a, count}, {b, count}] end)
    |> Enum.reduce(%{}, fn {element, count}, result -> Map.update(result, element, count, &(&1 + count)) end)
    # First and last element of the template and in the resulting string is the same. They are only counted once, since
    # they have no neighbours. Make sure they are counted twice like all other elements.
    |> Map.update!(first, &(&1 + 1))
    |> Map.update!(last, &(&1 + 1))
    # Now divide all counts by two
    |> Enum.into(%{}, fn {element, count} -> {element, div(count, 2)} end)
  end

  # Creates a stream of counts of element-pairs.
  # The first element is the template
  defp stream(pair_counts, rules) do
    Stream.unfold(pair_counts, fn pair_counts ->
      next =
        pair_counts
        |> Enum.flat_map(fn {{a, b}, count} ->
          element = Map.fetch!(rules, {a, b})

          [
            {{a, element}, count},
            {{element, b}, count}
          ]
        end)
        |> Enum.reduce(%{}, fn {pair, count}, result -> Map.update(result, pair, count, &(&1 + count)) end)

      {pair_counts, next}
    end)
  end

  defp parse(input) do
    [template | rules] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    template = String.graphemes(template)

    rules =
      Enum.into(rules, %{}, fn line ->
        [from, to] = String.split(line, " -> ")
        from = from |> String.graphemes() |> List.to_tuple()
        {from, to}
      end)

    {template, rules}
  end
end
