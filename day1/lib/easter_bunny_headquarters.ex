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
  iex> distance("")
  0
  iex> distance("R1")
  1
  iex> distance("R1, L1")
  2
  iex> distance("R2, L3")
  5
  iex> distance("R2, R2, R2")
  2
  iex> distance("R5, L5, R5, R3")
  12
  iex> distance("L1, L1, L1, L1")
  0
  iex> distance("R1, R1, R1, R1")
  0
  iex> distance("R20, L1, L19, L2")
  2
  """
  def distance(path) when is_binary(path) do
    path
    |> parse_path
    |> distance
  end
  def distance(path) when is_list(path) do
    origin = %Position{}
    final_position = destination(origin, path)
    distance(final_position.location)
  end
  def distance(nil), do: nil
  def distance(%Location{x: x, y: y}) do
    abs(x) + abs(y)
  end

  @doc """
  iex> distance_to_first_visited_twice("R1")
  nil
  iex> distance_to_first_visited_twice("R1, R1, R1, R1")
  0
  iex> distance_to_first_visited_twice("R2, R1, R1, R1, R1")
  1
  iex> distance_to_first_visited_twice("R8, R4, R4, R8")
  4
  """
  def distance_to_first_visited_twice(path) when is_binary(path) do
    path
    |> parse_path
    |> first_visited_twice
    |> distance
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
  def destination(position = %Position{}, [%Movement{spin: spin, steps: steps} | rest]) do
    direction = turn(position.direction, spin)
    location = move(direction, position.location.x, position.location.y, steps)
    trail = position.trail ++ trail(position.location, location)
    destination(%Position{direction: direction, location: location, trail: trail}, rest)
  end

  def trail(%Location{x: x, y: y}, %Location{x: x1, y: y1}) when y == y1 and x1 > x do
    for x <- (x + 1)..(x1) do
      %Location{x: x, y: y}
    end
  end
  def trail(%Location{x: x, y: y}, %Location{x: x1, y: y1}) when y == y1 and x1 < x do
    for x <- (x - 1)..(x1) do
      %Location{x: x, y: y}
    end
  end
  def trail(%Location{x: x, y: y}, %Location{x: x1, y: y1}) when x == x1 and y1 > y do
    for y <- (y + 1)..(y1) do
      %Location{x: x, y: y}
    end
  end
  def trail(%Location{x: x, y: y}, %Location{x: x1, y: y1}) when x == x1 and y1 < y do
    for y <- (y - 1)..(y1) do
      %Location{x: x, y: y}
    end
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

  defp move(:north, x, y, steps), do: %Location{x: x,         y: y + steps}
  defp move(:east, x, y, steps), do:  %Location{x: x + steps, y: y}
  defp move(:south, x, y, steps), do: %Location{x: x,         y: y - steps}
  defp move(:west, x, y, steps), do:  %Location{x: x - steps, y: y}

  def parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end

  def parse_step(<<char :: utf8>> <> step_string) do
    spin = [char]
    |> List.to_string
    |> String.downcase
    |> String.to_atom
    steps = String.to_integer(step_string)
    %Movement{spin: spin, steps: steps}
  end
end
