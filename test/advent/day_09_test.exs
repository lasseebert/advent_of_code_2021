defmodule Advent.Day09Test do
  use Advent.Test.Case

  alias Advent.Day09

  @example_input """
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  @puzzle_input File.read!("puzzle_inputs/day_09.txt")

  describe "part 1" do
    test "example" do
      assert Day09.part_1(@example_input) == 15
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_1(@puzzle_input) == 496
    end
  end

  describe "part 2" do
    test "example" do
      assert Day09.part_2(@example_input) == 1134
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_2(@puzzle_input) == 902_880
    end
  end
end
