defmodule Advent.Day14Test do
  use Advent.Test.Case

  alias Advent.Day14

  @example_input """
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
  """

  @puzzle_input File.read!("puzzle_inputs/day_14.txt")

  describe "part 1" do
    test "example" do
      assert Day14.part_1(@example_input) == 1588
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_1(@puzzle_input) == 2712
    end
  end

  describe "part 2" do
    test "example" do
      assert Day14.part_2(@example_input) == 2_188_189_693_529
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_2(@puzzle_input) == 8_336_623_059_567
    end
  end
end
