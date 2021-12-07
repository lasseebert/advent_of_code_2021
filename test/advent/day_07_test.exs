defmodule Advent.Day07Test do
  use Advent.Test.Case

  alias Advent.Day07

  @example_input """
  16,1,2,0,4,2,7,1,2,14
  """

  @puzzle_input File.read!("puzzle_inputs/day_07.txt")

  describe "part 1" do
    test "example" do
      assert Day07.part_1(@example_input) == 37
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_1(@puzzle_input) == 326_132
    end
  end

  describe "part 2" do
    test "example" do
      assert Day07.part_2(@example_input) == 168
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_2(@puzzle_input) == 88_612_508
    end
  end
end
