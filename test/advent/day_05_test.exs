defmodule Advent.Day05Test do
  use Advent.Test.Case

  alias Advent.Day05

  @example_input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  @puzzle_input File.read!("puzzle_inputs/day_05.txt")

  describe "part 1" do
    test "example" do
      assert Day05.part_1(@example_input) == 5
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_1(@puzzle_input) == 6666
    end
  end

  describe "part 2" do
    test "example" do
      assert Day05.part_2(@example_input) == 12
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_2(@puzzle_input) == 19_081
    end
  end
end
