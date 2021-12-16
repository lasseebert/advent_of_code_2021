defmodule Advent.Day16Test do
  use Advent.Test.Case

  alias Advent.Day16

  @puzzle_input File.read!("puzzle_inputs/day_16.txt")

  describe "part 1" do
    test "example 1" do
      assert Day16.part_1("8A004A801A8002F478") == 16
    end

    test "example 2" do
      assert Day16.part_1("620080001611562C8802118E34") == 12
    end

    test "example 3" do
      assert Day16.part_1("C0015000016115A2E0802F182340") == 23
    end

    test "example 4" do
      assert Day16.part_1("A0016C880162017C3686B18A3D4780") == 31
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_1(@puzzle_input) == 981
    end
  end

  describe "part 2" do
    [
      {"C200B40A82", 3},
      {"04005AC33890", 54},
      {"880086C3E88112", 7},
      {"CE00C43D881120", 9},
      {"D8005AC2A8F0", 1},
      {"F600BC2D8F", 0},
      {"9C005AC2F8F0", 0},
      {"9C0141080250320F1802104A08", 1}
    ]
    |> Enum.each(fn {input, expected} ->
      test "example #{input}" do
        assert Day16.part_2(unquote(input)) == unquote(expected)
      end
    end)

    test "large integer" do
      input =
        <<
          # Header
          0::3,
          4::3,
          # Four 0xF values
          1::1,
          0xF::4,
          1::1,
          0xF::4,
          1::1,
          0xF::4,
          0::1,
          0xF::4,
          # Filler
          0::6
        >>
        |> Base.encode16()

      assert Day16.part_2(input) == 0xFFFF
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_2(@puzzle_input) == 299_227_024_091
    end
  end
end
