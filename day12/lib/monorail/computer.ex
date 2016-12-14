defmodule Monorail.Computer do
  use GenServer

  defmodule State do
    defstruct program: [], registers: {0, 0, 0, 0}
  end

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_), do: {:ok, %State{}}

  def load(source_code), do: GenServer.call(__MODULE__, {:load, source_code})

  def registers, do: GenServer.call(__MODULE__, {:registers})

  def run, do: GenServer.call(__MODULE__, {:run}, 10000)

  def handle_call({:load, source_code}, _, state) do
    program = Monorail.Assembunny.parse(source_code)
    {:reply, :ok, %State{state | program: program, registers: {0, 0, 0, 0}}}
  end

  def handle_call({:registers}, _, state) do
    {:reply, state.registers, state}
  end

  def handle_call({:run}, _, state) do
    registers = Enum.reduce(state.program, state.registers, &apply_instruction/2)
    {:reply, :ok, %State{state | registers: registers}}
  end

  defp apply_instruction([instruction | operands], registers) do
    apply(Monorail.Instructions, instruction, [registers | operands])
  end
end
