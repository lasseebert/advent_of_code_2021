defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> paths_1()
    |> length()
  end

  # Small caves can only be visited once
  defp paths_1(mapping) do
    do_paths_1(mapping, ["start"])
  end

  defp do_paths_1(_mapping, ["end" | _] = path), do: [path]

  defp do_paths_1(mapping, [last | _] = path_so_far) do
    mapping
    |> Map.fetch!(last)
    |> Enum.reject(&(small?(&1) and &1 in path_so_far))
    |> Enum.flat_map(&do_paths_1(mapping, [&1 | path_so_far]))
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> path_count_2()
  end

  # A single small cave can be visited twice, all other small caves can still only be visited once
  defp path_count_2(mapping) do
    # Remove "start" as a destination for optimization
    mapping = Enum.into(mapping, %{}, fn {source, sinks} -> {source, List.delete(sinks, "start")} end)
    do_path_count_2(mapping, ["start"], false)
  end

  defp do_path_count_2(_mapping, ["end" | _], _used_twice), do: 1

  defp do_path_count_2(mapping, [last | _] = path_so_far, used_twice) do
    mapping
    |> Map.fetch!(last)
    |> Enum.filter(&can_visit?(&1, path_so_far, used_twice))
    |> Enum.map(&do_path_count_2(mapping, [&1 | path_so_far], used_twice or (small?(&1) and &1 in path_so_far)))
    |> Enum.sum()
  end

  defp can_visit?(cave, path_so_far, used_twice) do
    cond do
      cave == "end" -> true
      not small?(cave) -> true
      true -> cave not in path_so_far or not used_twice
    end
  end

  defp small?(cave) do
    String.downcase(cave) == cave
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.flat_map(fn [from, to] ->
      [
        {from, to},
        {to, from}
      ]
    end)
    |> Enum.reduce(%{}, fn {from, to}, mapping -> Map.update(mapping, from, [to], &[to | &1]) end)
  end
end
