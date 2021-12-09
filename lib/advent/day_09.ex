defmodule Advent.Day09 do
  @moduledoc """
  Day 09
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> low_points()
    |> Map.values()
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  defp risk_level(height), do: height + 1

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    heights = parse(input)

    heights
    |> low_points()
    |> Enum.map(&basin(&1, heights))
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
  end

  defp basin({pos, height}, heights) do
    basin = MapSet.new([pos])

    pos
    |> neighbours(heights)
    |> Enum.filter(fn {_pos, neighbour_height} -> neighbour_height > height and neighbour_height < 9 end)
    |> Enum.map(&basin(&1, heights))
    |> Enum.reduce(basin, &MapSet.union/2)
  end

  defp low_points(heights) do
    heights
    |> Enum.filter(&low_point?(&1, heights))
    |> Enum.into(%{})
  end

  defp low_point?({pos, height}, heights) do
    pos
    |> neighbours(heights)
    |> Enum.all?(fn {_pos, neighbour_height} -> height < neighbour_height end)
  end

  defp neighbours({x, y}, heights) do
    candidates = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    Map.take(heights, candidates)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {digit, x} ->
        digit = String.to_integer(digit)
        {{x, y}, digit}
      end)
    end)
    |> Enum.into(%{})
  end
end
