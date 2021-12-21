defmodule Advent.Day21Test do
  use Advent.Test.Case

  alias Advent.Day21

  @example_input """
  Player 1 starting position: 4
  Player 2 starting position: 8
  """

  @puzzle_input File.read!("puzzle_inputs/day_21.txt")

  describe "part 1" do
    test "example" do
      assert Day21.part_1(@example_input) == 739_785
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_1(@puzzle_input) == 678_468
    end
  end

  describe "part 2" do
    test "example" do
      assert Day21.part_2(@example_input) == 444_356_092_776_315
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) == 131_180_774_190_079
    end
  end
end
