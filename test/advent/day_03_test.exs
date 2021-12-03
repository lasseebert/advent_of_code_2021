defmodule Advent.Day03Test do
  use Advent.Test.Case

  alias Advent.Day03

  describe "part 1" do
    test "example" do
      input = """
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
      """

      assert Day03.part_1(input) == 198
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_03.txt"
             |> File.read!()
             |> Day03.part_1() == 4_001_724
    end
  end

  describe "part 2" do
    test "example" do
      input = """
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
      """

      assert Day03.part_2(input) == 230
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_03.txt"
             |> File.read!()
             |> Day03.part_2() == 587_895
    end
  end
end
