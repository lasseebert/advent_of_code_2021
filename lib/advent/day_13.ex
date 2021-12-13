defmodule Advent.Day13 do
  @moduledoc """
  Day 13
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {dots, [first_fold | _folds]} = parse(input)

    dots
    |> fold(first_fold)
    |> Enum.count()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: String.t()
  def part_2(input) do
    {dots, folds} = parse(input)

    text =
      folds
      |> Enum.reduce(dots, &fold(&2, &1))
      |> render()

    expected = """
      ## ###  #### ###  #     ##  #  # #  #
       # #  #    # #  # #    #  # # #  #  #
       # #  #   #  ###  #    #    ##   ####
       # ###   #   #  # #    # ## # #  #  #
    #  # # #  #    #  # #    #  # # #  #  #
     ##  #  # #### ###  ####  ### #  # #  #
    """

    ^expected = text
    "JRZBLGKH"
  end

  defp render(dots) do
    max_x = dots |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = dots |> Enum.map(&elem(&1, 1)) |> Enum.max()

    text =
      0..max_y
      |> Enum.map(fn y ->
        0..max_x
        |> Enum.map(fn x -> if(MapSet.member?(dots, {x, y}), do: "#", else: " ") end)
        |> Enum.join()
      end)
      |> Enum.join("\n")

    "#{text}\n"
  end

  defp fold(dots, {axis, fold_coord}) do
    dots
    |> Enum.flat_map(fn {x, y} ->
      case axis do
        :x ->
          cond do
            x == fold_coord -> []
            x < fold_coord -> [{x, y}]
            x > fold_coord -> [{x - 2 * (x - fold_coord), y}]
          end

        :y ->
          cond do
            y == fold_coord -> []
            y < fold_coord -> [{x, y}]
            y > fold_coord -> [{x, y - 2 * (y - fold_coord)}]
          end
      end
    end)
    |> MapSet.new()
  end

  defp parse(input) do
    [dots, folds] =
      input
      |> String.trim()
      |> String.split("\n\n", trim: true)

    dots = parse_dots(dots)
    folds = parse_folds(folds)

    {dots, folds}
  end

  defp parse_dots(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> MapSet.new()
  end

  defp parse_folds(folds) do
    folds
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn "fold along " <> text ->
      [axis, value] = String.split(text, "=")

      axis =
        case axis do
          "x" -> :x
          "y" -> :y
        end

      value = String.to_integer(value)

      {axis, value}
    end)
  end
end
