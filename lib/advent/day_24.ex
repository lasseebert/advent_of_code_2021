defmodule Advent.Day24 do
  @moduledoc """
  Day 24
  """

  @doc """
  Part 1

  Calculated by hand after understanding the algorithm
  """
  @spec part_1(String.t()) :: integer
  def part_1(_input) do
    serial = 12_996_997_829_399
    true = valid?(serial)
    serial
  end

  @doc """
  Part 2

  Calculated by hand after understanding the algorithm
  """
  @spec part_2(String.t()) :: integer
  def part_2(_input) do
    serial = 11_841_231_117_189
    true = valid?(serial)
    serial
  end

  def calculate_original(input, serial) do
    digits = Integer.digits(serial)

    input
    |> parse()
    |> run(digits)
    |> Map.fetch!(:z)
  end

  defp run(program, inputs) do
    vars = %{w: 0, x: 0, y: 0, z: 0}

    {vars, []} =
      Enum.reduce(program, {vars, inputs}, fn command, {vars, inputs} -> run_command(command, vars, inputs) end)

    vars
  end

  defp run_command({:inp, [var: var]}, vars, [input | inputs]) do
    {Map.update!(vars, var, fn _ -> input end), inputs}
  end

  defp run_command({inst, [var: var_1, var: var_2]}, vars, inputs) do
    run_command({inst, [var: var_1, num: Map.fetch!(vars, var_2)]}, vars, inputs)
  end

  defp run_command({inst, [var: var, num: num]}, vars, inputs) do
    {Map.update!(vars, var, fn value -> run_inst(inst, value, num) end), inputs}
  end

  defp run_inst(:add, a, b), do: a + b
  defp run_inst(:mul, a, b), do: a * b
  defp run_inst(:div, a, b), do: div(a, b)
  defp run_inst(:mod, a, b), do: rem(a, b)
  defp run_inst(:eql, a, b), do: if(a == b, do: 1, else: 0)

  def calculate_optimized(serial) do
    # At indexes 4, 7, 8, 9, 11, 12, 13 the stack will be popped _and_ it is possible to not push to the stack.
    # In all these seven locations we must avoid pushing to end up with an empty stack.
    #
    # The previous indexes that affect these indexes are:
    # 4: 3
    # 7: 6
    # 8: 5
    # 9: 2
    # 11: 10
    # 12: 1
    # 13: 0
    #
    # To get the largest serial, start with 9's and make it work in those 7 locaations.
    # To get the smallest serial, do the same but start with 1's
    as = [1, 1, 1, 1, 26, 1, 1, 26, 26, 26, 1, 26, 26, 26]
    bs = [14, 15, 12, 11, -5, 14, 15, -13, -16, -8, 15, -8, 0, -4]
    cs = [12, 7, 1, 2, 4, 15, 11, 5, 3, 9, 2, 3, 3, 11]

    serial
    |> Integer.digits()
    |> then(&Enum.zip([&1, as, bs, cs]))
    |> Enum.reduce([], fn {digit, a, b, c}, stack ->
      x =
        case stack do
          [] -> 0
          [last | _] -> last
        end

      x = x + b

      stack =
        case a do
          1 -> stack
          26 -> tl(stack)
        end

      if x == digit do
        stack
      else
        [digit + c | stack]
      end
    end)
    |> Enum.reverse()
    |> Enum.reduce(0, &(&2 * 26 + &1))
  end

  defp valid?(serial) do
    calculate_optimized(serial) == 0
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_command/1)
  end

  defp parse_command(line) do
    [inst | args] = String.split(line, " ")

    inst = parse_instruction(inst)
    args = Enum.map(args, &parse_arg/1)

    {inst, args}
  end

  defp parse_instruction("inp"), do: :inp
  defp parse_instruction("add"), do: :add
  defp parse_instruction("mul"), do: :mul
  defp parse_instruction("div"), do: :div
  defp parse_instruction("mod"), do: :mod
  defp parse_instruction("eql"), do: :eql

  defp parse_arg(input) do
    case input do
      "w" -> {:var, :w}
      "x" -> {:var, :x}
      "y" -> {:var, :y}
      "z" -> {:var, :z}
      number -> {:num, String.to_integer(number)}
    end
  end
end
