defmodule Advent.Day02 do
  @moduledoc """
  Day 02
  """

  @doc """
  Part 1

  Follow commands and multiply the resulting coordinates.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {dist, depth} =
      input
      |> parse()
      |> Enum.reduce({0, 0}, fn
        {:forward, count}, {dist, depth} -> {dist + count, depth}
        {:up, count}, {dist, depth} -> {dist, depth - count}
        {:down, count}, {dist, depth} -> {dist, depth + count}
      end)

    dist * depth
  end

  @doc """
  Part 2

  Follow command and use aim. Still multiply resulting coordinates.
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {dist, depth, _aim} =
      input
      |> parse()
      |> Enum.reduce({0, 0, 0}, fn
        {:down, count}, {dist, depth, aim} -> {dist, depth, aim + count}
        {:up, count}, {dist, depth, aim} -> {dist, depth, aim - count}
        {:forward, count}, {dist, depth, aim} -> {dist + count, depth + aim * count, aim}
      end)

    dist * depth
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [command, count] = String.split(line, " ")

    command =
      case command do
        "forward" -> :forward
        "up" -> :up
        "down" -> :down
      end

    count = String.to_integer(count)

    {command, count}
  end
end
