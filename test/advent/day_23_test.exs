defmodule Advent.Day23Test do
  use Advent.Test.Case

  alias Advent.Day23

  @example_input """
  #############
  #...........#
  ###B#C#B#D###
    #A#D#C#A#
    #########
  """

  @puzzle_input File.read!("puzzle_inputs/day_23.txt")

  describe "part 1" do
    @tag timeout: :infinity
    test "example" do
      assert Day23.part_1(@example_input) == 12_521
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_1(@puzzle_input) == 15_109
    end
  end

  describe "part 2" do
    test "example" do
      assert Day23.part_2(@example_input) == 44_169
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_2(@puzzle_input) == 53_751
    end
  end
end
