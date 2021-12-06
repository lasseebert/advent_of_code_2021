defmodule Advent.Day06 do
  @moduledoc """
  Day 06
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 80)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 256)
  end

  defp solve(input, time) do
    input
    |> parse()
    |> Enum.frequencies()
    |> iterate(time)
    |> Map.values()
    |> Enum.sum()
  end

  defp iterate(fish, 0), do: fish

  defp iterate(fish, time_left) when time_left > 0 do
    fish
    |> Enum.flat_map(fn {days, count} ->
      case days do
        0 -> [{6, count}, {8, count}]
        _other -> [{days - 1, count}]
      end
    end)
    |> Enum.reduce(%{}, fn {days, count}, fish -> Map.update(fish, days, count, &(&1 + count)) end)
    |> iterate(time_left - 1)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
