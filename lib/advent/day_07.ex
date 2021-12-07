defmodule Advent.Day07 do
  @moduledoc """
  Day 07
  """

  @doc """
  Part 1

  The median has the property if being the value with the shortest sum of distances.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    points = parse(input)
    median = median(points)

    points
    |> Enum.map(&abs(&1 - median))
    |> Enum.sum()
  end

  defp median(points) do
    mid_index = points |> length() |> div(2)

    points
    |> Enum.sort()
    |> Enum.at(mid_index)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    points = input |> parse() |> Enum.sort()
    find_least_fuel(points)
  end

  # This function is a parabola with the vertex at the horizontal value we are looking for.
  # This point must be within the min and max points in the data set.
  # So we start at the minimum and go up until the result is worse, then we know that we hit optimum in the last
  # iteration
  defp find_least_fuel(points) do
    freqs = Enum.frequencies(points)
    min = freqs |> Map.keys() |> Enum.min()

    min
    |> Stream.unfold(&{calc_usage(freqs, &1), &1 + 1})
    |> Stream.chunk_every(2, 1)
    |> Enum.find(fn [a, b] -> a < b end)
    |> hd()
  end

  defp calc_usage(freqs, center) do
    freqs
    |> Enum.map(fn {point, count} ->
      dist = abs(point - center)

      # Sum(1..dist) * count
      div(dist * (dist + 1), 2) * count
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
