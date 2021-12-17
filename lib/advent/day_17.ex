defmodule Advent.Day17 do
  @moduledoc """
  Day 17
  """

  @doc """
  Part 1

  The y-coordinate and velocity is completely independent of the x-coordinate.
  When vy (the velocity on the y axis) is positive, the y coordinates will generate a symmetric pattern.

  E.g. if vy starts as 3, the y coordinates will be: 0, 3, 5, 6, 6, 5, 3, 0, -4, ...
  vy can at most be so large that it will hit the bottom of the target area (y1), which means it must be the abs value
  of y1 minus 1.

  The max y coordinate will then be sum(1..vy)
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {{_x1, y1}, {_x2, _y2}} = parse(input)
    max_vy = y1 * -1 - 1

    div(max_vy * (max_vy + 1), 2)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {{_x1, y1}, {x2, _y2}} = target_area = parse(input)

    min_vy = y1
    max_vy = y1 * -1 - 1

    min_vx = 1
    max_vx = x2

    for vx <- min_vx..max_vx,
        vy <- min_vy..max_vy do
      {vx, vy}
    end
    |> Enum.filter(&hit?({0, 0}, &1, target_area))
    |> length()
  end

  defp hit?(pos, velocity, target_area) do
    cond do
      in_area?(pos, target_area) ->
        true

      beyond_area?(pos, target_area) ->
        false

      true ->
        {pos, velocity} = step(pos, velocity)
        hit?(pos, velocity, target_area)
    end
  end

  defp step({x, y}, {vx, vy}) do
    x = x + vx
    y = y + vy

    vx =
      case vx do
        n when n > 0 -> vx - 1
        0 -> 0
      end

    vy = vy - 1

    {{x, y}, {vx, vy}}
  end

  defp in_area?({x, y}, {{x1, y1}, {x2, y2}}), do: x1 <= x and x <= x2 and y1 <= y and y <= y2
  defp beyond_area?({x, y}, {{_x1, y1}, {x2, _y2}}), do: x > x2 or y < y1

  defp parse(input) do
    "target area: " <> coords = String.trim(input)

    [[x1, x2], [y1, y2]] =
      coords
      |> String.split(", ")
      |> Enum.map(fn axis ->
        [_, axis] = String.split(axis, "=")

        axis
        |> String.split("..")
        |> Enum.map(&String.to_integer/1)
      end)

    {{x1, y1}, {x2, y2}}
  end
end
