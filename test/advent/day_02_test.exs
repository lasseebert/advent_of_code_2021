defmodule Advent.Day02Test do
  use Advent.Test.Case

  alias Advent.Day02

  describe "part 1" do
    test "example" do
      input = """
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """

      assert Day02.part_1(input) == 150
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_02.txt"
             |> File.read!()
             |> Day02.part_1() == 1_813_801
    end
  end

  describe "part 2" do
    test "example" do
      input = """
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """

      assert Day02.part_2(input) == 900
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert "puzzle_inputs/day_02.txt"
             |> File.read!()
             |> Day02.part_2() == 1_960_569_556
    end
  end
end
