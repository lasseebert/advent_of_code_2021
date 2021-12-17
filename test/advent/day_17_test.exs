defmodule Advent.Day17Test do
  use Advent.Test.Case

  alias Advent.Day17

  @example_input "target area: x=20..30, y=-10..-5"

  @puzzle_input File.read!("puzzle_inputs/day_17.txt")

  describe "part 1" do
    test "example" do
      assert Day17.part_1(@example_input) == 45
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == 6903
    end
  end

  describe "part 2" do
    test "example" do
      assert Day17.part_2(@example_input) == 112
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_2(@puzzle_input) == 2351
    end
  end
end
