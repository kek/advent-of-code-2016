defmodule EasterBunnyHeadquarters do
  defmodule Position do
    defstruct direction: :north, x: 0, y: 0
  end

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
    origin = %Position{}
    %Position{x: x, y: y} = destination(origin, path)
    abs(x) + abs(y)
  end

  defp destination(position = %Position{}, []), do: position
  defp destination(%Position{direction: direction, x: x, y: y}, [{spin, steps} | rest]) do
    direction = turn(direction, spin)
    {x, y} = move(direction, x, y, steps)
    destination(%Position{direction: direction, x: x, y: y}, rest)
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

  defp parse_step(<<char :: utf8>> <> step_string) do
    direction = [char]
    |> List.to_string
    |> String.downcase
    |> String.to_atom
    steps = String.to_integer(step_string)
    {direction, steps}
  end

  defp parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end
end
