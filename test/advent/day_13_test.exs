defmodule Advent.Day13Test do
  use Advent.Test.Case

  alias Advent.Day13

  @example_input """
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
  """

  @puzzle_input File.read!("puzzle_inputs/day_13.txt")

  describe "part 1" do
    test "example" do
      assert Day13.part_1(@example_input) == 17
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_1(@puzzle_input) == 684
    end
  end

  describe "part 2" do
    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_2(@puzzle_input) == "JRZBLGKH"
    end
  end
end
