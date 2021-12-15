defmodule Advent.Day15 do
  @moduledoc """
  Day 15
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    graph =
      input
      |> parse()
      |> build_directed_graph()

    start = {0, 0}
    dest = graph |> Map.keys() |> Enum.max()

    djikstra(graph, start, dest)
  end

  defp djikstra(graph, start, dest) do
    unvisited = graph |> Map.keys() |> MapSet.new()
    distances = graph |> Map.keys() |> Enum.into(%{}, &{&1, :infinity}) |> Map.put(start, 0)
    current = start

    do_djikstra(graph, unvisited, distances, current, dest)
  end

  defp do_djikstra(_graph, _unvisited, distances, current, dest) when current == dest do
    Map.fetch!(distances, dest)
  end

  defp do_djikstra(graph, unvisited, distances, current, dest) do
    # If current = dest, we can stop here
    current_distance = Map.fetch!(distances, current)

    distances =
      graph
      |> Map.fetch!(current)
      |> Enum.filter(fn {node, _distance} -> node in unvisited end)
      |> Enum.reduce(distances, fn {node, node_distance}, distances ->
        new_distance = current_distance + node_distance

        Map.update!(distances, node, fn
          :infinity -> new_distance
          existing_distance when existing_distance <= new_distance -> existing_distance
          _larger -> new_distance
        end)
      end)

    unvisited = MapSet.delete(unvisited, current)

    current =
      unvisited
      |> Enum.map(&{&1, Map.fetch!(distances, &1)})
      |> Enum.reject(fn {_node, dist} -> dist == :infinity end)
      |> Enum.min_by(fn {_node, dist} -> dist end)
      |> elem(0)

    do_djikstra(graph, unvisited, distances, current, dest)
  end

  # Returns a map of %{node => [{node, weight}]}
  defp build_directed_graph(map) do
    Enum.into(map, %{}, fn {node, _risk} -> {node, neighbours(node, map)} end)
  end

  defp neighbours({x, y}, map) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.flat_map(fn pos ->
      case Map.fetch(map, pos) do
        {:ok, risk} -> [{pos, risk}]
        :error -> []
      end
    end)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {risk, x} -> {{x, y}, risk} end)
    end)
    |> Enum.into(%{})
  end
end
