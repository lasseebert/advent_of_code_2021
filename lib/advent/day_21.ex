defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    [start_pos_1, start_pos_2] = parse(input)

    %{
      positions: %{
        0 => start_pos_1,
        1 => start_pos_2
      },
      scores: %{
        0 => 0,
        1 => 0
      },
      next_die: 1,
      die_rolls: 0,
      next_turn: 0
    }
    |> Stream.unfold(fn game ->
      {roll, next_die} = die_rolls(game.next_die, 3)

      turn = game.next_turn

      positions = Map.update!(game.positions, turn, &(rem(&1 + roll - 1, 10) + 1))
      scores = Map.update!(game.scores, turn, &(&1 + Map.fetch!(positions, turn)))

      updated_game = %{
        game
        | next_die: next_die,
          die_rolls: game.die_rolls + 3,
          next_turn: 1 - game.next_turn,
          positions: positions,
          scores: scores
      }

      {game, updated_game}
    end)
    |> Enum.find(fn game -> game.scores |> Map.values() |> Enum.any?(&(&1 >= 1000)) end)
    |> then(fn game ->
      game.scores
      |> Map.values()
      |> Enum.min()
      |> Kernel.*(game.die_rolls)
    end)
  end

  defp die_rolls(value, 0), do: {0, value}

  defp die_rolls(value, count) do
    next_value =
      case value + 1 do
        101 -> 1
        n -> n
      end

    if count > 1 do
      {roll, next_value} = die_rolls(next_value, count - 1)
      {roll + value, next_value}
    else
      {value, next_value}
    end
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    [start_pos_1, start_pos_2] = parse(input)

    game = %{
      positions: %{0 => start_pos_1, 1 => start_pos_2},
      scores: %{0 => 0, 1 => 0},
      turn: 0,
      turn_part: 0
    }

    game
    |> count_wins()
    |> Enum.max()
  end

  defp count_wins(game) do
    {scores, _cache} = do_count_wins(game, %{})
    scores
  end

  defp do_count_wins(game, cache) do
    with :error <- cache_lookup(cache, game),
         :error <- get_win(game) do
      1..3
      |> Enum.reduce({[0, 0], cache}, fn die_roll, {[acc_s1, acc_s2], cache} ->
        {[s1, s2], cache} =
          game
          |> take_turn(die_roll)
          |> do_count_wins(cache)

        {[acc_s1 + s1, acc_s2 + s2], cache}
      end)
      |> then(fn {scores, cache} ->
        cache = cache_put(cache, game, scores)
        {scores, cache}
      end)
    else
      {:ok, result} -> {result, cache}
    end
  end

  defp take_turn(game, roll) do
    turn = game.turn
    turn_part = game.turn_part
    positions = Map.update!(game.positions, turn, &(rem(&1 + roll - 1, 10) + 1))

    scores =
      if turn_part == 2 do
        Map.update!(game.scores, turn, &(&1 + Map.fetch!(positions, turn)))
      else
        game.scores
      end

    %{
      game
      | turn: if(turn_part == 2, do: 1 - turn, else: turn),
        turn_part: if(turn_part == 2, do: 0, else: turn_part + 1),
        positions: positions,
        scores: scores
    }
  end

  defp get_win(game) do
    game.scores
    |> Enum.find(fn {_, score} -> score >= 21 end)
    |> case do
      {0, _} -> {:ok, [1, 0]}
      {1, _} -> {:ok, [0, 1]}
      nil -> :error
    end
  end

  defp cache_lookup(cache, game) do
    Map.fetch(cache, cache_key(game))
  end

  defp cache_put(cache, game, value) do
    Map.put(cache, cache_key(game), value)
  end

  defp cache_key(game) do
    {
      game.turn,
      game.turn_part,
      Map.fetch!(game.positions, 0),
      Map.fetch!(game.positions, 1),
      Map.fetch!(game.scores, 0),
      Map.fetch!(game.scores, 1)
    }
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.slice(&1, 28..-1))
    |> Enum.map(&String.to_integer/1)
  end
end
