defmodule Advent.Day04.Game do
  @moduledoc """
  Datastructure for the numbers in a game if bingo
  """

  use TypedStruct

  typedstruct enforce: true do
    field :used_numbers, MapSet.t()
    field :remaining_numbers, [integer()]
    field :last_used_number, integer() | nil
  end

  @doc """
  Builds a new Game from a list of numbers
  """
  @spec new([integer()]) :: t()
  def new(remaining_numbers) do
    %__MODULE__{
      used_numbers: MapSet.new(),
      remaining_numbers: remaining_numbers,
      last_used_number: nil
    }
  end

  @doc """
  Advances the game to the next turn (next number)
  """
  @spec next_turn(t) :: t
  def next_turn(game) do
    [next_number | remaining_numbers] = game.remaining_numbers
    used_numbers = MapSet.put(game.used_numbers, next_number)

    %{game | used_numbers: used_numbers, remaining_numbers: remaining_numbers, last_used_number: next_number}
  end
end
