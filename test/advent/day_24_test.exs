defmodule Advent.Day24Test do
  use Advent.Test.Case

  alias Advent.Day24

  @puzzle_input File.read!("puzzle_inputs/day_24.txt")

  describe "part 1" do
    test "optimized and original returns the same result" do
      random_serial =
        1..14
        |> Enum.map(fn _ ->
          Enum.random(1..9)
        end)
        |> Integer.undigits()

      original_result = Day24.calculate_original(@puzzle_input, random_serial)
      optimized_result = Day24.calculate_optimized(random_serial)

      assert original_result == optimized_result
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_1(@puzzle_input) == 12_996_997_829_399
    end
  end

  describe "part 2" do
    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_2(@puzzle_input) == 11_841_231_117_189
    end
  end
end
