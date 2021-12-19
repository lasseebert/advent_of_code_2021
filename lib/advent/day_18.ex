defmodule Advent.Day18 do
  @moduledoc """
  Day 18
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.reduce(&add(&2, &1))
    |> magnitude()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    trees = parse(input)

    for t1 <- trees, t2 <- trees, t1 != t2 do
      t1 |> add(t2) |> magnitude
    end
    |> Enum.max()
  end

  def magnitude(number) when is_integer(number), do: number
  def magnitude({left, right}), do: 3 * magnitude(left) + 2 * magnitude(right)

  defp add(tree_1, tree_2) do
    reduce({tree_1, tree_2})
  end

  defp reduce(tree) do
    with :error <- explode(tree),
         :error <- split(tree) do
      tree
    else
      {:ok, tree} -> reduce(tree)
    end
  end

  def explode(tree) do
    zipper = zipper_from_tree(tree)

    zipper_scan_next(zipper, fn
      {_front, [:start, a, b | _], %{depth: depth}} when is_integer(a) and is_integer(b) and depth >= 4 -> true
      _ -> false
    end)
    |> case do
      {:ok, {_front, [:start, a, b | _], options} = zipper} ->
        tree =
          zipper
          |> zipper_replace(4, [0])
          |> explode_left(a, options.index)
          |> explode_right(b)
          |> zipper_to_tree()

        {:ok, tree}

      :error ->
        :error
    end
  end

  defp explode_left(zipper, number, index) do
    zipper_scan_previous(zipper, fn
      {_front, [a | _], _} when is_integer(a) -> true
      _ -> false
    end)
    |> case do
      {:ok, {_front, [previous | _], _} = zipper} ->
        zipper = zipper_replace(zipper, 1, [previous + number])

        {:ok, zipper} =
          zipper_scan_next(zipper, fn
            {_, _, %{index: ^index}} -> true
            _ -> false
          end)

        zipper

      :error ->
        zipper
    end
  end

  defp explode_right(zipper, number) do
    zipper_scan_next(zipper, fn
      {_front, [a | _], _} when is_integer(a) -> true
      _ -> false
    end)
    |> case do
      {:ok, {_front, [next | _], _} = zipper} ->
        zipper_replace(zipper, 1, [next + number])

      :error ->
        zipper
    end
  end

  def split(tree) do
    zipper = zipper_from_tree(tree)

    zipper_scan_next(zipper, fn
      {_front, [a | _], _} when is_integer(a) and a >= 10 -> true
      _ -> false
    end)
    |> case do
      {:ok, {_front, [a | _], _} = zipper} ->
        left = div(a, 2)
        right = div(a, 2) + rem(a, 2)
        zipper = zipper_replace(zipper, 1, [:start, left, right, :stop])
        {:ok, zipper_to_tree(zipper)}

      :error ->
        :error
    end
  end

  # The TreeZipper data structure (not sure that is a thing)
  #
  # It's a zipper but for trees. It flattens the tree, but keeps track of index of nodes and depths.
  # Allows you to go back and forth in the tree in linear time complexity
  # A zipper is constructed and converted back in linear time too.

  defp zipper_from_tree(tree) do
    tokens = tree |> zipper_tokens |> List.flatten()
    {[], tokens, %{depth: 0, index: 0}}
  end

  defp zipper_tokens(value) when is_integer(value), do: [value]
  defp zipper_tokens({left, right}), do: [:start, zipper_tokens(left), zipper_tokens(right), :stop]

  defp zipper_to_tree({front, back, _}) do
    {tree, []} = parse_tree(Enum.reverse(front) ++ back)
    tree
  end

  defp zipper_replace({front, back, options}, length, replacement) do
    back = replacement ++ Enum.drop(back, length)
    {front, back, options}
  end

  defp zipper_scan_next(zipper, fun) do
    case zipper_next(zipper) do
      {:ok, zipper} ->
        if fun.(zipper) do
          {:ok, zipper}
        else
          zipper_scan_next(zipper, fun)
        end

      :error ->
        :error
    end
  end

  defp zipper_next({_front, [], _options}), do: :error

  defp zipper_next({front, [a | back], options}) do
    delta_depth =
      case a do
        :start -> 1
        :stop -> -1
        _ -> 0
      end

    options = %{
      depth: options.depth + delta_depth,
      index: options.index + 1
    }

    {:ok, {[a | front], back, options}}
  end

  defp zipper_scan_previous(zipper, fun) do
    case zipper_previous(zipper) do
      {:ok, zipper} ->
        if fun.(zipper) do
          {:ok, zipper}
        else
          zipper_scan_previous(zipper, fun)
        end

      :error ->
        :error
    end
  end

  defp zipper_previous({[], _back, _options}), do: :error

  defp zipper_previous({[a | front], back, options}) do
    delta_depth =
      case a do
        :start -> 1
        :stop -> -1
        _ -> 0
      end

    options = %{
      depth: options.depth - delta_depth,
      index: options.index - 1
    }

    {:ok, {front, [a | back], options}}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_snail_fish_number/1)
  end

  defp parse_snail_fish_number(line) do
    {tree, []} =
      line
      |> tokenize()
      |> parse_tree()

    tree
  end

  defp tokenize(line) do
    line
    |> String.graphemes()
    |> Enum.flat_map(fn
      "[" -> [:start]
      "]" -> [:stop]
      "," -> []
      number -> [String.to_integer(number)]
    end)
  end

  defp parse_tree([value | tokens]) when is_integer(value), do: {value, tokens}

  defp parse_tree([:start | tokens]) do
    {left, tokens} = parse_tree(tokens)
    {right, [:stop | tokens]} = parse_tree(tokens)
    {{left, right}, tokens}
  end
end
