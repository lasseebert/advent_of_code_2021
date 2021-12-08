defmodule Advent.Day08 do
  @moduledoc """
  Day 08
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.flat_map(fn {_samples, digits} -> digits end)
    |> Enum.count(&(length(&1) in [2, 3, 4, 7]))
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&decode_display/1)
    |> Enum.sum()
  end

  defp decode_display({samples, digits}) do
    samples_map = identify_samples(samples)
    wire_map = identify_wires(samples_map)
    true_digits = Enum.map(digits, &translate_digit(&1, wire_map))

    true_digits
    |> Enum.map(&decode_digit/1)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp decode_digit([:a, :b, :c, :e, :f, :g]), do: 0
  defp decode_digit([:c, :f]), do: 1
  defp decode_digit([:a, :c, :d, :e, :g]), do: 2
  defp decode_digit([:a, :c, :d, :f, :g]), do: 3
  defp decode_digit([:b, :c, :d, :f]), do: 4
  defp decode_digit([:a, :b, :d, :f, :g]), do: 5
  defp decode_digit([:a, :b, :d, :e, :f, :g]), do: 6
  defp decode_digit([:a, :c, :f]), do: 7
  defp decode_digit([:a, :b, :c, :d, :e, :f, :g]), do: 8
  defp decode_digit([:a, :b, :c, :d, :f, :g]), do: 9

  defp translate_digit(digit, wire_map) do
    digit
    |> Enum.map(&Map.fetch!(wire_map, &1))
    |> Enum.sort()
  end

  defp identify_samples(samples) do
    {[one], samples} = samples |> Enum.split_with(&(length(&1) == 2))
    {[seven], samples} = samples |> Enum.split_with(&(length(&1) == 3))
    {[four], samples} = samples |> Enum.split_with(&(length(&1) == 4))
    {[eight], samples} = samples |> Enum.split_with(&(length(&1) == 7))
    {[three], samples} = samples |> Enum.split_with(&(length(&1) == 5 and superset?(&1, one)))
    {[six], samples} = samples |> Enum.split_with(&(length(&1) == 6 and not superset?(&1, one)))
    {[nine], samples} = samples |> Enum.split_with(&(length(&1) == 6 and superset?(&1, three)))
    {[zero], samples} = samples |> Enum.split_with(&(length(&1) == 6))
    {[five], samples} = samples |> Enum.split_with(&(length(&1) == 5 and superset?(nine, &1)))
    [two] = samples

    %{
      zero: zero,
      one: one,
      two: two,
      three: three,
      four: four,
      five: five,
      six: six,
      seven: seven,
      eight: eight,
      nine: nine
    }
  end

  defp identify_wires(samples_map) do
    [a] = samples_map.seven -- samples_map.one
    [b] = samples_map.four -- samples_map.three
    [c] = samples_map.four -- samples_map.five
    [d] = samples_map.four -- samples_map.zero
    [e] = samples_map.eight -- samples_map.nine
    [f] = samples_map.seven -- samples_map.two
    [g] = (samples_map.five -- samples_map.four) -- samples_map.seven

    %{
      a: a,
      b: b,
      c: c,
      d: d,
      e: e,
      f: f,
      g: g
    }
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end

  defp superset?(a, b), do: Enum.all?(b, &(&1 in a))

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_display/1)
  end

  defp parse_display(line) do
    line
    |> String.split(" | ")
    |> Enum.map(fn section ->
      section
      |> String.split(" ")
      |> Enum.map(&parse_segments/1)
    end)
    |> List.to_tuple()
  end

  defp parse_segments(letters) do
    letters
    |> String.graphemes()
    |> Enum.sort()
  end
end
