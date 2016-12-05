defmodule EasterBunnyHeadquarters do
  defmodule Location do
    defstruct x: 0, y: 0
  end

  defmodule Position do
    defstruct direction: :north, location: %Location{}, trail: [%Location{}]
  end

  defmodule Movement do
    defstruct [:spin, :steps]
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
    %Position{direction: _, location: %Location{x: x, y: y}, trail: trail} = destination(origin, path)
    abs(x) + abs(y)
  end

  @doc """
  iex> EasterBunnyHeadquarters.first_visited_twice("R1")
  nil
  iex> EasterBunnyHeadquarters.first_visited_twice("R1, R1, R1, R1")
  %EasterBunnyHeadquarters.Location{x: 0, y: 0}
  """
  def first_visited_twice(path) when is_binary(path) do
    path
    |> parse_path
    |> first_visited_twice
  end
  def first_visited_twice(path) do
    origin = %Position{}
    %Position{trail: trail} = destination(origin, path)
    if Enum.uniq(trail) == trail do
      nil
    else
      Enum.reduce_while(trail, [], fn elem, acc ->
        if Enum.member?(acc, elem) do
          {:halt, elem}
        else
          {:cont, acc ++ [elem]}
        end
      end)
    end
  end

  def destination(position = %Position{}, []), do: position
  def destination(%Position{direction: direction, location: %Location{x: x, y: y}, trail: trail},
    [%Movement{spin: spin, steps: steps} | rest]) do
    direction = turn(direction, spin)
    location = move(direction, x, y, steps)
    trail = trail ++ [location]
    destination(%Position{direction: direction, location: location, trail: trail}, rest)
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

  defp move(:north, x, y, steps), do: %Location{x: x + steps, y: y}
  defp move(:east, x, y, steps), do: %Location{x: x, y: y + steps}
  defp move(:south, x, y, steps), do: %Location{x: x - steps, y: y}
  defp move(:west, x, y, steps), do: %Location{x: x, y: y - steps}

  defp parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end

  defp parse_step(<<char :: utf8>> <> step_string) do
    spin = [char]
    |> List.to_string
    |> String.downcase
    |> String.to_atom
    steps = String.to_integer(step_string)
    %Movement{spin: spin, steps: steps}
  end
end
