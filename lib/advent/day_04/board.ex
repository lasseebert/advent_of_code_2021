defmodule Advent.Day04.Board do
  @moduledoc """
  Data structure for a single bingo board
  """

  @type t :: %{coord => integer}
  @type coord :: {0..4, 0..4}

  @lines Enum.flat_map(0..4, fn index ->
           [
             Enum.map(0..4, &{index, &1}),
             Enum.map(0..4, &{&1, index})
           ]
         end)

  @doc """
  Builds a new Board from a map of coords to numbers
  """
  @spec new(t) :: t
  def new(map), do: map

  @doc """
  True if the board is winning
  """
  @spec win?(t, Enum.t()) :: boolean
  def win?(board, used_numbers) do
    Enum.any?(@lines, fn line ->
      Enum.all?(line, fn coord -> Map.fetch!(board, coord) in used_numbers end)
    end)
  end

  @doc """
  Returns the score of a winning board
  """
  @spec score(t, Enum.t(), integer) :: integer
  def score(board, used_numbers, last_used_number) do
    board
    |> Map.values()
    |> Enum.reject(&(&1 in used_numbers))
    |> Enum.sum()
    |> Kernel.*(last_used_number)
  end
end
