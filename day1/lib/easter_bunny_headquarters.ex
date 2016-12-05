defmodule EasterBunnyHeadquarters do
  @doc """
  iex> EasterBunnyHeadquarters.distance("")
  0
  iex> EasterBunnyHeadquarters.distance("R1")
  1
  iex> EasterBunnyHeadquarters.distance("R1, L1")
  2
  iex> EasterBunnyHeadquarters.distance("R2, L3")
  5
  iex> EasterBunnyHeadquarters.distance("R2, R2, R2")
  2
  iex> EasterBunnyHeadquarters.distance("R5, L5, R5, R3")
  12
  iex> EasterBunnyHeadquarters.distance("L1, L1, L1, L1")
  0
  iex> EasterBunnyHeadquarters.distance("R1, R1, R1, R1")
  0
  iex> EasterBunnyHeadquarters.distance("R20, L1, L19, L2")
  2
  """
  def distance(path) when is_binary(path) do
    path
    |> parse_path
    |> distance
  end
  def distance(path) when is_list(path) do
    origin = {:north, 0, 0}
    {_, x, y} = destination(origin, path)
    abs(x) + abs(y)
  end

  defp destination(position = {_, _, _}, []), do: position
  defp destination({direction, x, y}, [{spin, steps} | rest]) do
    direction = turn(direction, spin)
    {x, y} = move(direction, x, y, steps)
    destination({direction, x, y}, rest)
  end

  defp turn(direction, :r) do
    case direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end
  defp turn(direction, :l) do
    case direction do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
  end

  defp move(:north, x, y, steps), do: {x + steps, y}
  defp move(:east, x, y, steps), do: {x, y + steps}
  defp move(:south, x, y, steps), do: {x - steps, y}
  defp move(:west, x, y, steps), do: {x, y - steps}

  defp parse_step(<<char :: utf8>> <> steps_string) do
    {String.to_atom(String.downcase(List.to_string([char]))),
     String.to_integer(steps_string)}
  end

  defp parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end
end
