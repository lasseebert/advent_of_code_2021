defmodule Advent.Day19 do
  @moduledoc """
  Day 19
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> solve()
    |> Enum.flat_map(fn {beacons, _index, _offset} -> beacons end)
    |> Enum.uniq()
    |> length()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> solve()
    |> Enum.map(fn {_beacons, _index, offset} -> offset end)
    |> max_distance()
  end

  defp solve(input) do
    [{scanner_0, 0} | rest] = input |> parse() |> Enum.with_index()

    done = [{scanner_0, 0, {0, 0, 0}}]
    todo = rest
    mutations = mutations()

    find_beacons(done, todo, MapSet.new(), mutations)
  end

  defp find_beacons(done, [{scanner, index} | todo], tried_combinations, mutations) do
    new_tried_combinations =
      done
      |> Enum.map(fn {_, done_index, _offset} -> {done_index, index} end)
      |> MapSet.new()
      |> MapSet.union(tried_combinations)

    done
    |> Enum.reject(fn {_, done_index, _offset} -> {done_index, index} in tried_combinations end)
    |> Enum.reduce_while(nil, fn {done_scanner, _index, _offset}, nil ->
      case find_overlap(done_scanner, scanner, mutations) do
        nil -> {:cont, nil}
        result -> {:halt, result}
      end
    end)
    |> case do
      nil ->
        find_beacons(done, todo ++ [{scanner, index}], new_tried_combinations, mutations)

      {mutation, offset} ->
        mutated_coords = Enum.map(scanner, &(&1 |> transform(mutation) |> add(offset)))
        find_beacons([{mutated_coords, index, offset} | done], todo, new_tried_combinations, mutations)
    end
  end

  defp find_beacons(done, [], _tried_combinations, _mutations) do
    done
  end

  defp find_overlap(coords_1, coords_2, mutations) do
    mutations
    |> Enum.map(fn mutation ->
      mutated_coords = Enum.map(coords_2, &transform(&1, mutation))
      {mutation, mutated_coords}
    end)
    |> Enum.reduce_while(nil, fn {mutation, mutated_coords}, nil ->
      case get_matching_offset(coords_1, mutated_coords) do
        nil -> {:cont, nil}
        offset -> {:halt, {mutation, offset}}
      end
    end)
  end

  defp get_matching_offset(coords_1, coords_2) do
    for align_1 <- coords_1,
        align_2 <- coords_2 do
      subtract(align_1, align_2)
    end
    |> Enum.uniq()
    |> Enum.reduce_while(nil, fn offset, nil ->
      if count_matches_for_offset(coords_1, coords_2, offset) >= 12 do
        {:halt, offset}
      else
        {:cont, nil}
      end
    end)
  end

  defp count_matches_for_offset(coords_1, coords_2, offset) do
    coords_2
    |> Enum.map(&add(&1, offset))
    |> Enum.count(&(&1 in coords_1))
  end

  defp max_distance(coords) do
    for c1 <- coords,
        c2 <- coords do
      manhattan_distance(c1, c2)
    end
    |> Enum.max()
  end

  defp add({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}
  defp subtract({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}
  defp manhattan_distance({x1, y1, z1}, {x2, y2, z2}), do: abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)

  defp mutations do
    mutation_1 = [
      {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
      {{0, 1, 0}, {0, 0, 1}, {1, 0, 0}},
      {{0, 0, 1}, {1, 0, 0}, {0, 1, 0}}
    ]

    mutation_2 = [
      {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
      {{-1, 0, 0}, {0, -1, 0}, {0, 0, 1}},
      {{-1, 0, 0}, {0, 1, 0}, {0, 0, -1}},
      {{1, 0, 0}, {0, -1, 0}, {0, 0, -1}}
    ]

    mutation_3 = [
      {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
      {{0, 0, -1}, {0, -1, 0}, {-1, 0, 0}}
    ]

    for m1 <- mutation_1,
        m2 <- mutation_2,
        m3 <- mutation_3 do
      m1 |> dot(m2) |> dot(m3)
    end
  end

  defp transform(c, m) do
    {{m11, m12, m13}, {m21, m22, m23}, {m31, m32, m33}} = m
    {x, y, z} = c

    {
      x * m11 + y * m21 + z * m31,
      x * m12 + y * m22 + z * m32,
      x * m13 + y * m23 + z * m33
    }
  end

  defp dot(a, b) do
    {{a11, a12, a13}, {a21, a22, a23}, {a31, a32, a33}} = a
    {{b11, b12, b13}, {b21, b22, b23}, {b31, b32, b33}} = b

    {
      {
        a11 * b11 + a12 * b21 + a13 * b31,
        a11 * b12 + a12 * b22 + a13 * b32,
        a11 * b13 + a12 * b23 + a13 * b33
      },
      {
        a21 * b11 + a22 * b21 + a23 * b31,
        a21 * b12 + a22 * b22 + a23 * b32,
        a21 * b13 + a22 * b23 + a23 * b33
      },
      {
        a31 * b11 + a32 * b21 + a33 * b31,
        a31 * b12 + a32 * b22 + a33 * b32,
        a31 * b13 + a32 * b23 + a33 * b33
      }
    }
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_scanner/1)
  end

  defp parse_scanner(input) do
    [_header | lines] = String.split(input, "\n")
    Enum.map(lines, &parse_coord/1)
  end

  defp parse_coord(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
