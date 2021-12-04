defmodule Advent.Day04Test do
  use Advent.Test.Case

  alias Advent.Day04

  @example_input """
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
  """

  @puzzle_input File.read!("puzzle_inputs/day_04.txt")

  describe "part 1" do
    test "example" do
      assert Day04.part_1(@example_input) == 4512
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day04.part_1(@puzzle_input) == 23_177
    end
  end

  describe "part 2" do
    test "example" do
      assert Day04.part_2(@example_input) == 1924
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day04.part_2(@puzzle_input) == 6804
    end
  end
end
