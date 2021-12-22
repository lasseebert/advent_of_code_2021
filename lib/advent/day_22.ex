defmodule Advent.Day22 do
  @moduledoc """
  Day 22
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    # Really not needed since there are no inputs that intersects the init box that are not also covered by it
    extra_input = """
    off x=-100000..-51,y=-100000..100000,z=-100000..100000
    off x=51..100000,y=-100000..100000,z=-100000..100000
    off x=-100000..100000,y=-100000..-51,z=-100000..100000
    off x=-100000..100000,y=51..100000,z=-100000..100000
    off x=-100000..100000,y=-100000..100000,z=-100000..-51
    off x=-100000..100000,y=-100000..100000,z=51..100000
    """

    input = input <> extra_input
    init_box = {{-50, 50}, {-50, 50}, {-50, 50}}

    input
    |> parse()
    |> Enum.reject(fn {_mode, box} -> not intersects?(box, init_box) end)
    |> Enum.reduce([], &process_row(&2, &1))
    |> Enum.map(&size/1)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.reduce([], &process_row(&2, &1))
    |> Enum.map(&size/1)
    |> Enum.sum()
  end

  defp process_row(set, {:on, box}) do
    cond do
      Enum.any?(set, &covers?(&1, box)) ->
        set

      set_box = Enum.find(set, &intersects?(&1, box)) ->
        [box_1, box_2] = split(box, set_box)

        set
        |> process_row({:on, box_1})
        |> process_row({:on, box_2})

      true ->
        [box | set]
    end
  end

  defp process_row(set, {:off, box}) do
    Enum.flat_map(set, &remove(&1, box))
  end

  defp remove(box, clear_box) do
    cond do
      covers?(clear_box, box) -> []
      intersects?(clear_box, box) -> box |> split(clear_box) |> Enum.flat_map(&remove(&1, clear_box))
      true -> [box]
    end
  end

  defp covers?({b1x, b1y, b1z}, {b2x, b2y, b2z}) do
    covers_1d?(b1x, b2x) and
      covers_1d?(b1y, b2y) and
      covers_1d?(b1z, b2z)
  end

  defp covers_1d?({x11, x12}, {x21, x22}) do
    x11 <= x21 and x12 >= x22
  end

  defp intersects?({b1x, b1y, b1z}, {b2x, b2y, b2z}) do
    intersect_1d?(b1x, b2x) and
      intersect_1d?(b1y, b2y) and
      intersect_1d?(b1z, b2z)
  end

  defp intersect_1d?({x11, x12}, {x21, x22}) do
    not Range.disjoint?(x11..x12, x21..x22)
  end

  # Split according to the other box, so that it splits on one axis in two parts that are either not touching or covered
  defp split({x, y, z}, {ox, oy, oz}) do
    cond do
      not covers_1d?(ox, x) ->
        [x1, x2] = split_1d(x, ox)
        [{x1, y, z}, {x2, y, z}]

      not covers_1d?(oy, y) ->
        [y1, y2] = split_1d(y, oy)
        [{x, y1, z}, {x, y2, z}]

      not covers_1d?(oz, z) ->
        [z1, z2] = split_1d(z, oz)
        [{x, y, z1}, {x, y, z2}]
    end
  end

  defp split_1d({x1, x2}, {ox1, ox2}) do
    if x1 < ox1 do
      [{x1, ox1 - 1}, {ox1, x2}]
    else
      [{x1, ox2}, {ox2 + 1, x2}]
    end
  end

  defp size({{x1, x2}, {y1, y2}, {z1, z2}}) do
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  # Example line:
  # on x=10..12,y=10..12,z=10..12
  defp parse_line(line) do
    [mode, coords] = String.split(line, " ")

    mode =
      case mode do
        "on" -> :on
        "off" -> :off
      end

    coords =
      coords
      |> String.split(",")
      |> Enum.map(fn axis ->
        [_axis, values] = String.split(axis, "=")
        values |> String.split("..") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> List.to_tuple()

    {mode, coords}
  end
end
