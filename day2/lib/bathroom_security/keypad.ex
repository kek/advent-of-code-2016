defmodule BathroomSecurity.Keypad do
  use GenServer

  defstruct code: "", finger: "5", map: BathroomSecurity.Keypad.OrdinaryMap

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_), do: {:ok, %__MODULE__{}}

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

  defp get_code, do: GenServer.call(__MODULE__, {:get_code})

  def reset, do: GenServer.call(__MODULE__, {:reset})

  def set_map(map), do: GenServer.call(__MODULE__, {:set_map, map})

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
    finger = state.map.neighbor(state.finger, direction)
    {:reply, :ok, %{state | finger: finger}}
  end

  def handle_call({:press_button}, _, state) do
    code = "#{state.code}#{state.finger}"
    state = %{state | code: code}
    {:reply, :ok, state}
  end

  def handle_call({:get_code}, _, state) do
    {:reply, state.code, state}
  end

  def handle_call({:reset}, _, _) do
    {:reply, :ok, %__MODULE__{}}
  end

  def handle_call({:set_map, map}, _, state) do
    {:reply, :ok, %{state | map: map}}
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
