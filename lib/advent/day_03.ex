defmodule Advent.Day03 do
  @moduledoc """
  Day 03
  """

  @doc """
  Part 1

  Find the gamma rate and the epsilon rate. Multiply them together.
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    numbers = parse(input)

    gamma_rate = calc_rate(numbers, 0)
    epsilon_rate = calc_rate(numbers, 1)

    gamma_rate * epsilon_rate
  end

  defp calc_rate(numbers, zero_mapping) do
    numbers
    |> Enum.zip()
    |> Enum.map_join(fn digit_list ->
      counts =
        digit_list
        |> Tuple.to_list()
        |> Enum.frequencies()

      case {Map.get(counts, 0, 0), Map.get(counts, 1, 0)} do
        {zeroes, ones} when zeroes > ones -> zero_mapping
        {zeroes, ones} when zeroes < ones -> 1 - zero_mapping
      end
    end)
    |> String.to_integer(2)
  end

  @doc """
  Part 2

  Next, you should verify the life support rating, which can be determined by multiplying the oxygen generator rating
  by the CO2 scrubber rating.
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    numbers = parse(input)

    oxygen_rating = calc_rating(numbers, 0)
    co2_rating = calc_rating(numbers, 1)

    oxygen_rating * co2_rating
  end

  defp calc_rating(numbers, zero_mapping) do
    numbers = Enum.zip(numbers, numbers)
    do_calc_rating(numbers, zero_mapping)
  end

  defp do_calc_rating([{number, _left}], _zero_mapping), do: number |> Enum.join() |> String.to_integer(2)

  defp do_calc_rating([_ | _] = numbers, zero_mapping) do
    most_common =
      numbers
      |> Enum.map(fn {_number, [digit | _]} -> digit end)
      |> Enum.frequencies()
      |> then(fn counts ->
        case {Map.get(counts, 0, 0), Map.get(counts, 1, 0)} do
          {zeroes, ones} when zeroes > ones -> zero_mapping
          {zeroes, ones} when zeroes <= ones -> 1 - zero_mapping
        end
      end)

    numbers
    |> Enum.filter(fn {_number, [digit | _]} -> digit == most_common end)
    |> Enum.map(fn {number, [_digit | digits]} -> {number, digits} end)
    |> do_calc_rating(zero_mapping)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn
        "0" -> 0
        "1" -> 1
      end)
    end)
  end
end
