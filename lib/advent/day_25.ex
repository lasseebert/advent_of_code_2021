defmodule Advent.Day25 do
  @moduledoc """
  Day 25
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    map = parse(input)
    max_coord = map |> Map.keys() |> Enum.max()

    map
    |> Stream.unfold(&{&1, step(&1, max_coord)})
    |> Stream.with_index()
    |> Stream.chunk_every(2, 1)
    |> Enum.find(fn [{m1, _}, {m2, _}] -> m1 == m2 end)
    |> then(fn [{_, _i1}, {_, i2}] -> i2 end)
  end

  defp step(map, max_coord) do
    Enum.reduce([:east, :south], map, &half_step(&2, &1, max_coord))
  end

  defp half_step(map, dir, max_coord) do
    map
    |> Enum.filter(fn {_, cucumber} -> cucumber == dir end)
    |> Enum.map(fn {coord, _} -> {coord, next(coord, dir, max_coord)} end)
    |> Enum.reject(fn {_, next} -> Map.fetch!(map, next) != nil end)
    |> Enum.reduce(map, fn {from, to}, map ->
      map
      |> Map.update!(from, fn ^dir -> nil end)
      |> Map.update!(to, fn nil -> dir end)
    end)
  end

  defp next({max_x, y}, :east, {max_x, _}), do: {0, y}
  defp next({x, y}, :east, {_max_x, _}), do: {x + 1, y}
  defp next({x, max_y}, :south, {_, max_y}), do: {x, 0}
  defp next({x, y}, :south, {_, _max_y}), do: {x, y + 1}

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(fn
        ">" -> :east
        "v" -> :south
        "." -> nil
      end)
      |> Enum.with_index()
      |> Enum.map(fn {value, x} -> {{x, y}, value} end)
    end)
    |> Enum.into(%{})
  end
end
