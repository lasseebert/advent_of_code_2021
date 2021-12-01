defmodule Advent.Day01Test do
  use Advent.Test.Case

  alias Advent.Day01

  describe "part 1" do
    test "example" do
      input = """
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
      """

      assert Day01.part_1(input) == 7
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_01.txt"
             |> File.read!()
             |> Day01.part_1() == 1754
    end
  end

  describe "part 2" do
    test "example" do
      input = """
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
      """

      assert Day01.part_2(input) == 5
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_01.txt"
             |> File.read!()
             |> Day01.part_2() == 1789
    end
  end
end
