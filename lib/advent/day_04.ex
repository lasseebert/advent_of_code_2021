defmodule Advent.Day04 do
  @moduledoc """
  Day 04
  """

  alias Advent.Day04.Board
  alias Advent.Day04.Game

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {game, boards} = parse(input)
    play(game, boards)
  end

  defp play(game, boards) do
    game = Game.next_turn(game)

    boards
    |> Enum.filter(&Board.win?(&1, game.used_numbers))
    |> case do
      [] -> play(game, boards)
      [board] -> Board.score(board, game.used_numbers, game.last_used_number)
    end
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {game, boards} = parse(input)
    play_to_loose(game, boards)
  end

  defp play_to_loose(game, boards) do
    game = Game.next_turn(game)
    winning_boards = Enum.filter(boards, &Board.win?(&1, game.used_numbers))
    remaining_boards = Enum.reduce(winning_boards, boards, &List.delete(&2, &1))

    if remaining_boards == [] do
      [looser] = boards
      Board.score(looser, game.used_numbers, game.last_used_number)
    else
      play_to_loose(game, remaining_boards)
    end
  end

  defp parse(input) do
    [numbers | board_lines] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    game =
      numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Game.new()

    boards =
      board_lines
      |> Enum.chunk_every(5)
      |> Enum.map(&parse_board/1)

    {game, boards}
  end

  defp parse_board(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {field, x} ->
        {{x, y}, field}
      end)
    end)
    |> Enum.into(%{})
    |> Board.new()
  end
end
