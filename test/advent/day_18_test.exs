defmodule Advent.Day18Test do
  use Advent.Test.Case

  alias Advent.Day18

  @example_input """
  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
  """

  @puzzle_input File.read!("puzzle_inputs/day_18.txt")

  describe "explode" do
    test "example 1" do
      assert Day18.explode({{{{{9, 8}, 1}, 2}, 3}, 4}) == {:ok, {{{{0, 9}, 2}, 3}, 4}}
    end

    test "example 2" do
      assert Day18.explode({7, {6, {5, {4, {3, 2}}}}}) == {:ok, {7, {6, {5, {7, 0}}}}}
    end

    test "example 3" do
      assert Day18.explode({{6, {5, {4, {3, 2}}}}, 1}) == {:ok, {{6, {5, {7, 0}}}, 3}}
    end

    test "example 4" do
      assert Day18.explode({{3, {2, {1, {7, 3}}}}, {6, {5, {4, {3, 2}}}}}) ==
               {:ok, {{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}}
    end

    test "example 5" do
      assert Day18.explode({{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}) == {:ok, {{3, {2, {8, 0}}}, {9, {5, {7, 0}}}}}
    end
  end

  describe "split" do
    test "mini example" do
      assert Day18.split({10, 0}) == {:ok, {{5, 5}, 0}}
      assert Day18.split({11, 0}) == {:ok, {{5, 6}, 0}}
    end

    test "example 1" do
      assert Day18.split({{{{0, 7}, 4}, {15, {0, 13}}}, {1, 1}}) == {:ok, {{{{0, 7}, 4}, {{7, 8}, {0, 13}}}, {1, 1}}}
    end
  end

  describe "magnitude" do
  end

  describe "part 1" do
    test "example" do
      assert Day18.part_1(@example_input) == 4140
    end

    test "small example" do
      input = """
      [[[[4,3],4],4],[7,[[8,4],9]]]
      [1,1]
      """

      assert Day18.part_1(input) == 1384
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_1(@puzzle_input) == 4008
    end
  end

  describe "part 2" do
    test "example" do
      assert Day18.part_2(@example_input) == 3993
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_2(@puzzle_input) == 4667
    end
  end
end
