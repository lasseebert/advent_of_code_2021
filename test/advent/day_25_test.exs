defmodule Advent.Day25Test do
  use Advent.Test.Case

  alias Advent.Day25

  @example_input """
  v...>>.vv>
  .vv>>.vv..
  >>.>v>...v
  >>v>>.>.v.
  v>v.vv.v..
  >.>>..v...
  .vv..>.>v.
  v.v..>>v.v
  ....v..v.>
  """

  @puzzle_input File.read!("puzzle_inputs/day_25.txt")

  describe "part 1" do
    test "example" do
      assert Day25.part_1(@example_input) == 58
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day25.part_1(@puzzle_input) == 489
    end
  end
end
