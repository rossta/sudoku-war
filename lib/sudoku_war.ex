defmodule SudokuWar do
  use Application

  @id_length Application.get_env(:sudoku_war, :id_length)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SudokuWar.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SudokuWar.Endpoint, []),
      # Start your own worker by calling: SudokuWar.Worker.start_link(arg1, arg2, arg3)
      # worker(SudokuWar.Worker, [arg1, arg2, arg3]),
      supervisor(SudokuWar.Game.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SudokuWar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SudokuWar.Endpoint.config_change(changed, removed)
    :ok
  end

  def generate_player_id do
    @id_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end

  def generate_game_id do
    @id_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end
end
