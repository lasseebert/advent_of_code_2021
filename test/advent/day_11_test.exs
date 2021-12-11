defmodule Advent.Day11Test do
  use Advent.Test.Case

  alias Advent.Day11

  @example_input """
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  @puzzle_input File.read!("puzzle_inputs/day_11.txt")

  describe "part 1" do
    test "example" do
      assert Day11.part_1(@example_input) == 1656
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_1(@puzzle_input) == 1591
    end
  end

  describe "part 2" do
    test "example" do
      assert Day11.part_2(@example_input) == 195
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_2(@puzzle_input) == 314
    end
  end
end
