defmodule SudokuWar.Game do
  use GenServer
  require Logger

  alias SudokuWar.Game.Board
  alias SudokuWar.Game.Supervisor, as: GameSupervisor

  defstruct [
    id: nil,
    attacker: nil,
    defender: nil,
    turns: [],
    over: false,
    winner: nil,
    grid: nil,
  ]

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  @doc """
  Add a player to a game
  """
  def join(id, player_id, pid), do: try_call(id, {:join, player_id, pid})

  @doc """
  Returns the game's state
  """
  def get_data(id), do: try_call(id, :get_data)

  def enter_value(id, data), do: try_call(id, {:enter_value, data})

  def stop(id) do
    whereis(id) |> GameSupervisor.stop_game()
  end

  def whereis(id) do
    ref(id) |> GenServer.whereis()
  end

  @doc """
  Called when a player leaves the game
  """
  def player_left(id, player_id), do: try_call(id, {:player_left, player_id})

  # SERVER

  def init(id) do
    {:ok, %__MODULE__{id: id}}
  end

  def handle_call({:join, player_id, pid}, _from, game) do
    Logger.debug "Handling :join for #{player_id} in Game #{game.id}"

    cond do
      Enum.member?([game.attacker, game.defender], player_id) ->
        {:reply, {:ok, self}, game}
      game.attacker != nil and game.defender != nil ->
        {:reply, {:error, "No more players allowed"}, game}
      true ->
        Process.flag(:trap_exit, true)
        Process.monitor(pid)

        game = add_player(game, player_id)

        {:ok, board_pid} = find_or_create_board(game)
        Process.monitor(board_pid)

        {:reply, {:ok, self}, game}
    end
  end

  def handle_call(:get_data, _from, game) do
    Logger.debug "Handling :get_data for Game #{game.id}"

    game_data = Map.put(game, :board, Board.get_data(game.id))

    {:reply, game_data, game}
  end

  def handle_call({:enter_value, {key, value}}, _from, game) do
    Logger.debug "Handling :enter_value for Game #{game.id}: {#{key}, #{value}}"

    board_data = Board.enter_value(game.id, {key, value})

    game_data = Map.put(game, :board, board_data)

    {:reply, game_data, game}
  end

  def handle_call({:player_left, player_id}, _from, game) do
    Logger.debug "Handling :player_left for #{player_id} in Game #{game.id}"

    game = %{game | over: true, winner: get_opponents_id(game, player_id)}

    {:reply, {:ok, game}, game}
  end

  defp add_player(%__MODULE__{attacker: nil} = game, player_id), do: %{game | attacker: player_id}
  defp add_player(%__MODULE__{defender: nil} = game, player_id), do: %{game | defender: player_id}

  defp get_opponents_id(%__MODULE__{attacker: player_id, defender: nil}, player_id), do: nil
  defp get_opponents_id(%__MODULE__{attacker: player_id, defender: defender}, player_id), do: defender
  defp get_opponents_id(%__MODULE__{defender: player_id, attacker: attacker}, player_id), do: attacker

  defp find_or_create_board(game) do
    Board.find_or_create(game.id)
  end

  defp ref(id), do: {:global, {:game, id}}

  defp try_call(id, message) do
    case whereis(id) do
      nil ->
        {:error, "Game does not exist"}
      game ->
        GenServer.call(game, message)
    end
  end
end
