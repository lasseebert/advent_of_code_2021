defmodule Advent.Day06Test do
  use Advent.Test.Case

  alias Advent.Day06

  @example_input """
  3,4,3,1,2
  """

  @puzzle_input File.read!("puzzle_inputs/day_06.txt")

  describe "part 1" do
    test "example" do
      assert Day06.part_1(@example_input) == 5934
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_1(@puzzle_input) == 345_387
    end
  end

  describe "part 2" do
    test "example" do
      assert Day06.part_2(@example_input) == 26_984_457_539
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_2(@puzzle_input) == 1_574_445_493_136
    end
  end
end
