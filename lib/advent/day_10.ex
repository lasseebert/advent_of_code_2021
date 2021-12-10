defmodule Advent.Day10 do
  @moduledoc """
  Day 10
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&first_illegal_char/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&syntax_error_score/1)
    |> Enum.sum()
  end

  defp syntax_error_score({:close, "("}), do: 3
  defp syntax_error_score({:close, "["}), do: 57
  defp syntax_error_score({:close, "{"}), do: 1_197
  defp syntax_error_score({:close, "<"}), do: 25_137

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.filter(&(first_illegal_char(&1) == nil))
    |> Enum.map(&end_sequence/1)
    |> Enum.map(&score_end_sequence/1)
    |> middle()
  end

  defp first_illegal_char(line), do: do_first_illegal_char([], line)
  defp do_first_illegal_char([{:open, char} | front], [{:close, char} | back]), do: do_first_illegal_char(front, back)
  defp do_first_illegal_char(front, [{:open, _char} = next | back]), do: do_first_illegal_char([next | front], back)
  defp do_first_illegal_char(_front, [{:close, _char} = next | _back]), do: next
  defp do_first_illegal_char(_front, []), do: nil

  defp end_sequence(line), do: do_end_sequence([], line)
  defp do_end_sequence([{:open, char} | front], [{:close, char} | back]), do: do_end_sequence(front, back)
  defp do_end_sequence(front, [{:open, _char} = next | back]), do: do_end_sequence([next | front], back)
  defp do_end_sequence(front, []), do: Enum.map(front, fn {:open, char} -> {:close, char} end)

  defp score_end_sequence(line) do
    Enum.reduce(line, 0, fn char, acc -> acc * 5 + score_end_sequence_char(char) end)
  end

  defp score_end_sequence_char({:close, "("}), do: 1
  defp score_end_sequence_char({:close, "["}), do: 2
  defp score_end_sequence_char({:close, "{"}), do: 3
  defp score_end_sequence_char({:close, "<"}), do: 4

  defp middle(scores) do
    scores
    |> Enum.sort()
    |> Enum.at(scores |> length() |> div(2))
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn
      "(" -> {:open, "("}
      "[" -> {:open, "["}
      "{" -> {:open, "{"}
      "<" -> {:open, "<"}
      ")" -> {:close, "("}
      "]" -> {:close, "["}
      "}" -> {:close, "{"}
      ">" -> {:close, "<"}
    end)
  end
end
