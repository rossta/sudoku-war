defmodule SudokuWar.GameChannel do
  use SudokuWar.Web, :channel
  require Logger

  alias SudokuWar.{Game, Game.Board}

  def join("game:" <> game_id, _payload, socket) do
    player_id = socket.assigns.player_id

    case Game.join(game_id, player_id, socket.channel_pid) do
      {:ok, _pid} ->
        {:ok, assign(socket, :game_id, game_id)}
      {:error, reason} -> {:error, %{reason: reason}}
    end
  end

  def handle_in("game:joined", _message, socket) do
    game_id = socket.assigns.game_id
    player_id = socket.assigns.player_id

    Logger.debug "Broadcasting player joined #{socket.assigns.game_id}"

    board = Board.get_data(game_id)
    broadcast! socket, "game:player_joined", %{player_id: player_id, board: board}

    {:noreply, socket}
  end

  def handle_in("game:get_data", _message, socket) do
    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id

    game = Game.get_data(game_id)

    {:reply, {:ok, %{game: game}}, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"Terminating GameChannel #{socket.assigns.game_id} #{inspect reason}"

    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id

    case Game.player_left(game_id, player_id) do
      {:ok, game} ->

        Game.stop(game_id)

        broadcast(socket, "game:over", %{game: game})
        broadcast(socket, "game:player_left", %{player_id: player_id})

        :ok
      _ ->
        :ok
    end
  end

  def handle_info(_, socket), do: {:noreply, socket}
end
