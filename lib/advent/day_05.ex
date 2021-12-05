defmodule Advent.Day05 do
  @moduledoc """
  Day 05
  """

  @type coord :: {integer(), integer()}
  @type line :: {coord, coord}

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.filter(&straigth_line?/1)
    |> count_overlaps()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> count_overlaps()
  end

  defp count_overlaps(lines) do
    lines
    |> Enum.reduce(%{}, &plot_line(&2, &1))
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end

  defp plot_line(map, line) do
    line
    |> line_coords()
    |> Enum.reduce(map, fn coord, map -> Map.update(map, coord, 1, &(&1 + 1)) end)
  end

  defp line_coords({{x1, y1}, {x2, y2}}) do
    dx = delta(x1, x2)
    dy = delta(y1, y2)

    {x1, y1}
    |> Stream.unfold(fn {x, y} -> {{x, y}, {x + dx, y + dy}} end)
    |> Stream.take_while(fn {x, y} -> {x - dx, y - dy} != {x2, y2} end)
  end

  defp delta(x1, x2) do
    case x2 - x1 do
      0 -> 0
      n when n > 0 -> 1
      _ -> -1
    end
  end

  defp straigth_line?({{x1, y1}, {x2, y2}}), do: x1 == x2 or y1 == y2

  @spec parse(String.t()) :: [line()]
  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(&parse_coord/1)
      |> List.to_tuple()
    end)
  end

  @spec parse_coord(String.t()) :: coord()
  defp parse_coord(coord_string) do
    coord_string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
