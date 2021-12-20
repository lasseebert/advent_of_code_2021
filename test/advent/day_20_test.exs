defmodule Advent.Day20Test do
  use Advent.Test.Case

  alias Advent.Day20

  @example_input """
  ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

  #..#.
  #....
  ##..#
  ..#..
  ..###
  """

  @puzzle_input File.read!("puzzle_inputs/day_20.txt")

  describe "part 1" do
    test "example" do
      assert Day20.part_1(@example_input) == 35
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_1(@puzzle_input) == 5391
    end
  end

  describe "part 2" do
    test "example" do
      assert Day20.part_2(@example_input) == 3351
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_2(@puzzle_input) == 16_383
    end
  end
end
