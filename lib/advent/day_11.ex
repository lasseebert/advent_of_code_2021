defmodule Advent.Day11 do
  @moduledoc """
  Day 11
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> iterate()
    |> Enum.take(100)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> iterate()
    |> Enum.find_index(&(&1 == 100))
    |> then(&(&1 + 1))
  end

  # Returns a stream of number of flashes in each step
  defp iterate(map) do
    Stream.unfold(map, &step/1)
  end

  defp step(map) do
    # Step 1 - increase energy levels of each octopus
    map = Enum.into(map, %{}, fn {coord, energy} -> {coord, energy + 1} end)

    # Step 2 - Flash each octopus with energy > 9 and give energy to neighbours, which might also flash
    worklist = Map.keys(map)
    flashed = MapSet.new()
    {flashed, map} = do_flash(flashed, map, worklist)

    # Step 3 - Reset all flashed to zero energy
    map = Enum.reduce(flashed, map, &Map.put(&2, &1, 0))

    {Enum.count(flashed), map}
  end

  defp do_flash(flashed, map, []) do
    {flashed, map}
  end

  defp do_flash(flashed, map, [coord | worklist]) do
    if Map.fetch!(map, coord) > 9 and not MapSet.member?(flashed, coord) do
      flashed = MapSet.put(flashed, coord)
      neighbours = find_neighbours(coord)
      map = Enum.reduce(neighbours, map, &Map.update!(&2, &1, fn energy -> energy + 1 end))
      worklist = neighbours ++ worklist
      do_flash(flashed, map, worklist)
    else
      do_flash(flashed, map, worklist)
    end
  end

  defp find_neighbours({x, y}) do
    for dx <- -1..1, dy <- -1..1 do
      {x + dx, y + dy}
    end
    |> Enum.reject(fn {x1, y1} -> {x1, y1} == {x, y} or x1 < 0 or x1 > 9 or y1 < 0 or y1 > 9 end)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {energy, x} -> {{x, y}, energy} end)
    end)
    |> Enum.into(%{})
  end
end
