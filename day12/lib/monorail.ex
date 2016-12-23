defmodule Monorail do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Monorail.Computer, [])
      # Starts a worker by calling: Monorail.Worker.start_link(arg1, arg2, arg3)
      # worker(Monorail.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Monorail.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
