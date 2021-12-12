defmodule Advent.Day12Test do
  use Advent.Test.Case

  alias Advent.Day12

  @example_input """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  @puzzle_input File.read!("puzzle_inputs/day_12.txt")

  describe "part 1" do
    test "example" do
      assert Day12.part_1(@example_input) == 10
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_1(@puzzle_input) == 4413
    end
  end

  describe "part 2" do
    test "example" do
      assert Day12.part_2(@example_input) == 36
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_2(@puzzle_input) == 118_803
    end
  end
end
