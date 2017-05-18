defmodule ShutdownApp do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    IO.inspect "#{__MODULE__}.start"

    children = [
      worker(ShutdownApp.Worker, [], shutdown: 123_456)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def stop(_) do
    IO.inspect "#{__MODULE__}.stop"
  end
end

defmodule ShutdownApp.Worker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    IO.inspect "#{__MODULE__}.init"
    Process.flag(:trap_exit, true)
    Process.send_after(self(), :ping, 2000)
    {:ok, {}}
  end

  def handle_info(:ping, state) do
    IO.inspect "#{__MODULE__}.ping"
    Process.send_after(self(), :ping, 2000)
    {:noreply, state}
  end

  def terminate(_, _) do
    IO.inspect "#{__MODULE__}.terminate"
    Process.sleep(1_000_000)
  end
end
