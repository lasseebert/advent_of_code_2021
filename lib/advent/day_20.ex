defmodule Advent.Day20 do
  @moduledoc """
  Day 20
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 2)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 50)
  end

  defp solve(input, iterations) do
    {algo, map} = parse(input)

    image = %{
      map: map,
      box: {{0, 0}, map |> Map.keys() |> Enum.max()},
      default: 0
    }

    image
    |> Stream.unfold(fn image -> {image, step(image, algo)} end)
    |> Enum.at(iterations)
    |> then(fn image ->
      image.map
      |> Map.values()
      |> Enum.count(&(&1 == 1))
    end)
  end

  defp step(image, algo) do
    {{min_x, min_y}, {max_x, max_y}} = box = expand_box(image.box)

    map =
      for x <- min_x..max_x,
          y <- min_y..max_y do
        {x, y}
      end
      |> Enum.into(%{}, fn coord ->
        pixel = compute_pixel(coord, image, algo)
        {coord, pixel}
      end)

    %{
      image
      | map: map,
        box: box,
        default: if(Map.fetch!(algo, 0) == 0, do: 0, else: 1 - image.default)
    }
  end

  defp expand_box({{x1, y1}, {x2, y2}}), do: {{x1 - 1, y1 - 1}, {x2 + 1, y2 + 1}}

  defp compute_pixel(coord, image, algo) do
    coord
    |> algo_index(image)
    |> then(&Map.fetch!(algo, &1))
  end

  defp algo_index({x, y}, image) do
    for dy <- -1..1,
        dx <- -1..1 do
      {x + dx, y + dy}
    end
    |> Enum.map(&lookup_pixel(&1, image))
    |> Enum.reduce(&(&2 * 2 + &1))
  end

  defp lookup_pixel(coord, image) do
    Map.get(image.map, coord, image.default)
  end

  defp parse(input) do
    [algo, map] = input |> String.trim() |> String.split("\n\n", trim: true)

    512 = String.length(algo)

    algo =
      algo
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {char, index} ->
        value =
          case char do
            "." -> 0
            "#" -> 1
          end

        {index, value}
      end)

    map =
      map
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.map(fn
          "." -> 0
          "#" -> 1
        end)
        |> Enum.with_index()
        |> Enum.map(fn {value, x} -> {{x, y}, value} end)
      end)
      |> Enum.into(%{})

    {algo, map}
  end
end
