defmodule Advent.Day08Test do
  use Advent.Test.Case

  alias Advent.Day08

  @example_input """
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  """

  @puzzle_input File.read!("puzzle_inputs/day_08.txt")

  describe "part 1" do
    test "example" do
      assert Day08.part_1(@example_input) == 26
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_1(@puzzle_input) == 381
    end
  end

  describe "part 2" do
    test "example" do
      assert Day08.part_2(@example_input) == 61_229
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_2(@puzzle_input) == 1_023_686
    end
  end
end
