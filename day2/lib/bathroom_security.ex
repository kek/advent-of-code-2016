defmodule BathroomSecurity do
  @moduledoc "BathroomSecurity OTP Application"
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(BathroomSecurity.Keypad, [], name: BathroomSecurity.Keypad)
    ]

    opts = [strategy: :one_for_one, name: BathroomSecurity.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
