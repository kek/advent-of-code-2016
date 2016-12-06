defmodule BathroomSecurity.Keypad do
  use GenServer

  defstruct code: "", finger: "5"

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  @doc """
  iex> code("")
  ""
  """
  def code(instructions) do
    instructions
    |> parse_instructions
    |> calculate_code
  end

  defp calculate_code(instructions) do
    Enum.each(instructions, &add_row/1)
    get_code
  end

  defp get_code do
    GenServer.call(__MODULE__, {:get_code})
  end

  def reset do
    GenServer.call(__MODULE__, {:reset})
  end

  defp add_row(row) do
    Enum.each(row, &move_finger(&1))
    press_button
  end

  defp move_finger(direction) do
    GenServer.call(__MODULE__, {:move_finger, direction})
  end

  defp press_button do
    GenServer.call(__MODULE__, {:press_button})
  end

  def handle_call({:move_finger, direction}, _, state) do
    finger = neighbor(state.finger, direction)
    {:reply, :ok, %__MODULE__{state | finger: finger}}
  end

  def handle_call({:press_button}, _, state) do
    code = "#{state.code}#{state.finger}"
    state = %__MODULE__{state | code: code}
    {:reply, :ok, state}
  end

  def handle_call({:get_code}, _, state) do
    {:reply, state.code, state}
  end

  def handle_call({:reset}, _, _) do
    {:reply, :ok, %__MODULE__{}}
  end

  # 1 2 3
  # 4 5 6
  # 7 8 9
  defp neighbor(f, "U") do
    case f do
      "4" -> "1"
      "5" -> "2"
      "6" -> "3"
      "7" -> "4"
      "8" -> "5"
      "9" -> "6"
      x -> x
    end
  end
  defp neighbor(f, "D") do
    case f do
      "1" -> "4"
      "2" -> "5"
      "3" -> "6"
      "4" -> "7"
      "5" -> "8"
      "6" -> "9"
      x -> x
    end
  end
  defp neighbor(f, "L") do
    case f do
      "2" -> "1"
      "3" -> "2"
      "5" -> "4"
      "6" -> "5"
      "8" -> "7"
      "9" -> "8"
      x -> x
    end
  end
  defp neighbor(f, "R") do
    case f do
      "1" -> "2"
      "2" -> "3"
      "4" -> "5"
      "5" -> "6"
      "7" -> "8"
      "8" -> "9"
      x -> x
    end
  end

  @doc """
  iex> parse_instructions("")
  []
  iex> parse_instructions("U")
  [["U"]]
  iex> parse_instructions(" UD RL ")
  [["U", "D"], ["R", "L"]]
  """
  def parse_instructions(instructions) do
    instructions
    |> String.split
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.codepoints/1)
  end
end
