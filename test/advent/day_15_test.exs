defmodule Advent.Day15Test do
  use Advent.Test.Case

  alias Advent.Day15

  @example_input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  @puzzle_input File.read!("puzzle_inputs/day_15.txt")

  describe "part 1" do
    test "example" do
      assert Day15.part_1(@example_input) == 40
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_1(@puzzle_input) == 687
    end
  end

  describe "part 2" do
    test "example" do
      assert Day15.part_2(@example_input) == 315
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_2(@puzzle_input) == 2957
    end
  end
end
