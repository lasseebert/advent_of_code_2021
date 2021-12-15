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
    goal = graph |> Map.keys() |> Enum.max()

    djikstra(graph, start, goal)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    graph =
      input
      |> parse()
      |> extend_map()
      |> build_directed_graph()

    start = {0, 0}
    goal = graph |> Map.keys() |> Enum.max()

    djikstra(graph, start, goal)
  end

  defp djikstra(graph, start, goal) do
    unvisited = graph |> Map.keys() |> MapSet.new()
    distances = graph |> Map.keys() |> Enum.into(%{}, &{&1, :infinity}) |> Map.put(start, 0)
    queue = build_bucket_queue() |> push_bucket_queue(start, 0)

    do_djikstra(graph, unvisited, distances, queue, goal)
  end

  defp do_djikstra(graph, unvisited, distances, queue, goal) do
    {current, queue} = pop_bucket_queue(queue)

    cond do
      # We have reached the destination
      current == goal ->
        Map.fetch!(distances, goal)

      # current is already visited. This can happen if it was re-prioritized in the queue
      current not in unvisited ->
        do_djikstra(graph, unvisited, distances, queue, goal)

      # Go on with Djikstra
      true ->
        current_distance = Map.fetch!(distances, current)

        {distances, queue} =
          graph
          |> Map.fetch!(current)
          |> Enum.filter(fn {node, _distance} -> node in unvisited end)
          |> Enum.reduce({distances, queue}, fn {node, node_distance}, {distances, queue} ->
            new_distance = current_distance + node_distance

            case Map.fetch!(distances, node) do
              existing_distance when is_integer(existing_distance) and existing_distance <= new_distance ->
                {distances, queue}

              _larger ->
                distances = Map.put(distances, node, new_distance)
                minimum_remaining_distance = manhattan_distance(node, goal)
                queue = push_bucket_queue(queue, node, new_distance + minimum_remaining_distance)
                {distances, queue}
            end
          end)

        unvisited = MapSet.delete(unvisited, current)

        do_djikstra(graph, unvisited, distances, queue, goal)
    end
  end

  # Bucket queue implementation in three functions
  defp build_bucket_queue(), do: {%{}, 0}
  defp push_bucket_queue({map, lowest}, node, cost), do: {Map.update(map, cost, [node], &[node | &1]), lowest}

  defp pop_bucket_queue({map, lowest}) do
    case Map.fetch(map, lowest) do
      {:ok, [next]} -> {next, {Map.delete(map, lowest), lowest}}
      {:ok, [next | rest]} -> {next, {Map.put(map, lowest, rest), lowest}}
      :error -> pop_bucket_queue({map, lowest + 1})
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
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

  defp extend_map(map) do
    {max_x, max_y} = map |> Map.keys() |> Enum.max()
    size_x = max_x + 1
    size_y = max_y + 1

    deltas =
      for dx <- 0..4,
          dy <- 0..4 do
        {dx, dy}
      end
      |> Enum.map(fn {dx, dy} ->
        {{dx * size_x, dy * size_y}, dx + dy}
      end)

    map
    |> Enum.flat_map(fn {{x, y}, risk} ->
      Enum.map(deltas, fn {{dx, dy}, addon_risk} ->
        new_risk =
          case risk + addon_risk do
            n when n <= 9 -> n
            n when n > 9 -> n - 9
          end

        {{x + dx, y + dy}, new_risk}
      end)
    end)
    |> Enum.into(%{})
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
