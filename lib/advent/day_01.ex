defmodule Advent.Day01 do
  @moduledoc """
  Day 01
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> count_increases()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> running_average(3)
    |> count_increases()
  end

  defp count_increases(depths) do
    depths
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [d1, d2] -> d2 > d1 end)
  end

  defp running_average(depths, count) do
    depths
    |> Enum.chunk_every(count, 1, :discard)
    |> Enum.map(&Enum.sum/1)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
