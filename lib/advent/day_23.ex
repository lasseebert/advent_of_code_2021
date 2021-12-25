defmodule Advent.Day23 do
  @moduledoc """
  Day 23
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse(:part_one)
    |> solve()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse(:part_two)
    |> solve()
  end

  def solve(map) do
    cache = %{}
    {energy, _cache} = min_energy_to_goal(map, cache)
    energy
  end

  defp min_energy_to_goal(map, cache) do
    if done?(map) do
      {0, cache}
    else
      case Map.fetch(cache, map) do
        {:ok, energy} -> {energy, cache}
        :error -> do_min_energy_to_goal(map, cache)
      end
    end
  end

  defp do_min_energy_to_goal(map, cache) do
    map
    |> Enum.reject(fn {_coord, amphipod} -> is_nil(amphipod) end)
    |> Enum.map(fn {coord, _amphipod} -> coord end)
    |> Enum.flat_map(&possible_moves(&1, map))
    |> case do
      [] ->
        Map.put(cache, map, :infinity)
        {:infinity, cache}

      moves ->
        {energy, cache} =
          Enum.reduce(moves, {:infinity, cache}, fn {next_map, step_energy}, {acc_energy, cache} ->
            {sub_energy, cache} = min_energy_to_goal(next_map, cache)
            acc_energy = sub_energy |> add_energy(step_energy) |> min_energy(acc_energy)
            {acc_energy, cache}
          end)

        cache = Map.put(cache, map, energy)
        {energy, cache}
    end
  end

  defp possible_moves({_, 0} = src, map) do
    amphipod = Map.fetch!(map, src)
    dest_col = home_column(amphipod)

    1..max_row(map)
    |> Enum.flat_map(fn row ->
      dest = {dest_col, row}

      if possible_move?(src, dest, amphipod, map) do
        [create_move(map, src, dest)]
      else
        []
      end
    end)
  end

  defp possible_moves({src_col, src_row} = src, map) when src_row > 0 do
    amphipod = Map.fetch!(map, src)
    belongs_to_row = home_column(amphipod)

    if src_col != belongs_to_row or
         Enum.any?((src_row + 1)..max_row(map)//1, fn row -> Map.fetch!(map, {src_col, row}) != amphipod end) do
      [0, 1, 3, 5, 7, 9, 10]
      |> Enum.flat_map(fn col ->
        dest = {col, 0}

        if possible_move?(src, dest, amphipod, map) do
          [create_move(map, src, dest)]
        else
          []
        end
      end)
    else
      []
    end
  end

  defp possible_move?({src_col, 0}, {dest_col, dest_row}, amphipod, map) when dest_row > 0 do
    row_coords = for x <- src_col..dest_col, x != src_col, do: {x, 0}

    Enum.all?(row_coords, &(Map.fetch!(map, &1) == nil)) and
      Enum.all?(1..dest_row//1, &(Map.fetch!(map, {dest_col, &1}) == nil)) and
      Enum.all?((dest_row + 1)..max_row(map)//1, &(Map.fetch!(map, {dest_col, &1}) == amphipod))
  end

  defp possible_move?({src_col, src_row}, {dest_col, 0}, _amphipod, map) when src_row > 0 do
    row_coords = for x <- src_col..dest_col, do: {x, 0}

    Enum.all?(row_coords, &(Map.fetch!(map, &1) == nil)) and
      Enum.all?(1..(src_row - 1)//1, &(Map.fetch!(map, {src_col, &1}) == nil))
  end

  defp create_move(map, {src_col, src_row} = src, {dest_col, dest_row} = dest) do
    amphipod = Map.fetch!(map, src)

    map =
      map
      |> Map.put(src, nil)
      |> Map.put(dest, amphipod)

    energy = (abs(src_col - dest_col) + abs(src_row - dest_row)) * single_energy(amphipod)
    {map, energy}
  end

  defp single_energy(:a), do: 1
  defp single_energy(:b), do: 10
  defp single_energy(:c), do: 100
  defp single_energy(:d), do: 1000

  defp max_row(map) do
    case Map.fetch(map, {2, 4}) do
      {:ok, _} -> 4
      :error -> 2
    end
  end

  defp home_column(:a), do: 2
  defp home_column(:b), do: 4
  defp home_column(:c), do: 6
  defp home_column(:d), do: 8

  defp amphipod_for_column(2), do: :a
  defp amphipod_for_column(4), do: :b
  defp amphipod_for_column(6), do: :c
  defp amphipod_for_column(8), do: :d

  defp done?(map) do
    Enum.all?(map, fn {coord, amphipod} ->
      expected_amphipod =
        case coord do
          {_, 0} -> nil
          {x, _} -> amphipod_for_column(x)
        end

      amphipod == expected_amphipod
    end)
  end

  defp min_energy(:infinity, energy), do: energy
  defp min_energy(energy, :infinity), do: energy
  defp min_energy(e1, e2), do: Enum.min([e1, e2])

  defp add_energy(:infinity, _), do: :infinity
  defp add_energy(_, :infinity), do: :infinity
  defp add_energy(e1, e2), do: e1 + e2

  defp parse(input, part) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.drop(2)
    |> Enum.take(2)
    |> then(fn [line_1, line_2] ->
      case part do
        :part_one ->
          [line_1, line_2]

        :part_two ->
          [
            line_1,
            "  #D#C#B#A#",
            "  #D#B#A#C#",
            line_2
          ]
      end
    end)
    |> Enum.join()
    |> String.graphemes()
    |> Enum.reject(&(&1 in ["#", " "]))
    |> Enum.map(fn
      "A" -> :a
      "B" -> :b
      "C" -> :c
      "D" -> :d
    end)
    |> Enum.chunk_every(4)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {amphipod, col_index} -> {{col_index * 2 + 2, row_index + 1}, amphipod} end)
    end)
    |> Enum.into(%{})
    |> then(fn map ->
      0..10
      |> Enum.reduce(map, &Map.put(&2, {&1, 0}, nil))
    end)
  end
end
