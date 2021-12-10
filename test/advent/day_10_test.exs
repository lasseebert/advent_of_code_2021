defmodule Advent.Day10Test do
  use Advent.Test.Case

  alias Advent.Day10

  @example_input """
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  @puzzle_input File.read!("puzzle_inputs/day_10.txt")

  describe "part 1" do
    test "example" do
      assert Day10.part_1(@example_input) == 26_397
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_1(@puzzle_input) == 311_895
    end
  end

  describe "part 2" do
    test "example" do
      assert Day10.part_2(@example_input) == 288_957
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_2(@puzzle_input) == 2_904_180_541
    end
  end
end
