defmodule SudokuWar.Game.Supervisor do
  use Supervisor

  alias SudokuWar.{Game}

  def start_link, do: Supervisor.start_link(
    __MODULE__,
    :ok,
    name: __MODULE__
  )

  def init(:ok) do
    children = [
      worker(Game, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def create_game(id), do: Supervisor.start_child(__MODULE__, [id])

  def current_games do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(&game_data/1)
  end

  def stop_game(pid) do
    Supervisor.terminate_child(__MODULE__, pid)
  end

  defp game_data({_id, pid, _type, _modules}) do
    pid
    |> GenServer.call(:get_data)
    |> Map.take([:id, :attacker, :defender, :turns, :over, :winner])
  end
end
