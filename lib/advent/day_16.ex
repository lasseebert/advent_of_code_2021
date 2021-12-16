defmodule Advent.Day16 do
  @moduledoc """
  Day 16
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> sum_versions()
  end

  defp sum_versions(%{type: :literal} = packet), do: packet.version

  defp sum_versions(%{type: {:operator, _}} = packet) do
    sub = packet.sub_packets |> Enum.map(&sum_versions/1) |> Enum.sum()
    packet.version + sub
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> simplify()
    |> calculate()
  end

  defp simplify(%{type: :literal} = packet), do: packet.value
  defp simplify(%{type: {:operator, operator}} = packet), do: {operator, Enum.map(packet.sub_packets, &simplify/1)}

  defp calculate(number) when is_integer(number), do: number
  defp calculate({op, subs}), do: do_calculate({op, Enum.map(subs, &calculate/1)})

  defp do_calculate({:sum, subs}), do: Enum.sum(subs)
  defp do_calculate({:prod, subs}), do: Enum.reduce(subs, &Kernel.*/2)
  defp do_calculate({:min, subs}), do: Enum.min(subs)
  defp do_calculate({:max, subs}), do: Enum.max(subs)
  defp do_calculate({:gt, [s1, s2]}), do: if(s1 > s2, do: 1, else: 0)
  defp do_calculate({:lt, [s1, s2]}), do: if(s1 < s2, do: 1, else: 0)
  defp do_calculate({:eq, [s1, s2]}), do: if(s1 == s2, do: 1, else: 0)

  defp parse(input) do
    raw =
      input
      |> String.trim()
      |> Base.decode16!()

    {packet, _rest} = read_packet(raw)
    packet
  end

  defp read_packet(raw) do
    {version, raw} = read_fixed_int(raw, 3)
    {type_id, raw} = read_fixed_int(raw, 3)
    read_packet_content(raw, version, type_id)
  end

  defp read_packet_content(raw, version, 4 = _type_id) do
    {value, raw} = read_literal(0, raw)

    packet = %{
      type: :literal,
      version: version,
      value: value
    }

    {packet, raw}
  end

  defp read_packet_content(raw, version, type_id) do
    {length_type_id, raw} = read_fixed_int(raw, 1)
    read_operator_content(raw, version, type_id, length_type_id)
  end

  defp read_operator_content(raw, version, type_id, 0 = _length_type_id) do
    {length, raw} = read_fixed_int(raw, 15)
    {raw_content, raw} = take_bits(raw, length)
    sub_packets = read_packets_to_end(raw_content)

    packet = %{
      type: {:operator, parse_operator(type_id)},
      version: version,
      sub_packets: sub_packets
    }

    {packet, raw}
  end

  defp read_operator_content(raw, version, type_id, 1 = _length_type_id) do
    {length, raw} = read_fixed_int(raw, 11)

    {sub_packets, raw} = Enum.map_reduce(1..length, raw, fn _, raw -> read_packet(raw) end)

    packet = %{
      type: {:operator, parse_operator(type_id)},
      version: version,
      sub_packets: sub_packets
    }

    {packet, raw}
  end

  defp read_packets_to_end(<<>>), do: []

  defp read_packets_to_end(raw) do
    {packet, raw} = read_packet(raw)
    [packet | read_packets_to_end(raw)]
  end

  defp read_fixed_int(raw, bits) do
    <<value::size(bits), rest::bitstring>> = raw
    {value, rest}
  end

  defp take_bits(raw, bits) do
    <<value::size(bits), raw::bitstring>> = raw
    {<<value::size(bits)>>, raw}
  end

  defp read_literal(acc, raw) do
    <<flag::1, value::4, raw::bitstring>> = raw

    acc = acc * 16 + value

    case flag do
      0 -> {acc, raw}
      1 -> read_literal(acc, raw)
    end
  end

  defp parse_operator(0), do: :sum
  defp parse_operator(1), do: :prod
  defp parse_operator(2), do: :min
  defp parse_operator(3), do: :max
  defp parse_operator(5), do: :gt
  defp parse_operator(6), do: :lt
  defp parse_operator(7), do: :eq
end
