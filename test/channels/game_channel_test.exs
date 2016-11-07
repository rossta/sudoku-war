defmodule SudokuWar.GameChannelTest do
  use SudokuWar.ChannelCase, async: true

  alias SudokuWar.GameChannel
  alias SudokuWar.Game.Supervisor, as: GameSupervisor
  alias SudokuWar.{PlayerSocket, GameChannel, Game}
  @player_id SudokuWar.generate_player_id

  setup do
    game_id = SudokuWar.generate_game_id

    {:ok, game} = GameSupervisor.create_game(game_id)
    {:ok, socket} = connect(PlayerSocket, %{"id" => @player_id})

    {:ok, game_id: game_id, game: game, socket: socket}
  end

  test "joining an invalid game channel", %{socket: socket} do
    assert {:error, %{reason: "Game does not exist"}} = subscribe_and_join(socket, GameChannel, "game:invalid")
  end

  test "stopping the game kills the game", %{game_id: game_id, game: game, socket: socket} do
    game_ref = Process.monitor(game)

    {:ok, _, socket} = subscribe_and_join(socket, GameChannel, "game:" <> game_id)

    Process.unlink(socket.channel_pid)

    push socket, "game:stop", %{game_id: game_id}
    assert_receive {:DOWN, ^game_ref, :process, ^game, _}

    assert {:error, "Game does not exist"} = Game.join(game_id, @player_id, socket.channel_pid)
  end

  test "leaving the game channel braodcasts player left", %{game_id: game_id, socket: socket} do
    {:ok, _, socket} = subscribe_and_join(socket, GameChannel, "game:" <> game_id)

    Process.unlink(socket.channel_pid)

    ref = leave(socket)
    assert_reply ref, :ok
    assert_broadcast "game:player_left", %{player_id: @player_id}

    assert {:ok, _, _socket} = subscribe_and_join(socket, GameChannel, "game:" <> game_id)
  end

  test "entering value on game grid", %{game_id: game_id, socket: socket} do
    {:ok, _, socket} = subscribe_and_join(socket, GameChannel, "game:" <> game_id)

    push socket, "game:enter_value", %{key: "A2", value: "4"}
    assert_broadcast "game:board_updated", %{board: _}

    game = Game.get_data(game_id)
    board = game.board
    assert board.grid["A2"] == "4"

    push socket, "game:enter_value", %{key: "I9", value: "6"}
    assert_broadcast "game:board_updated", %{board: _}

    game = Game.get_data(game_id)
    board = game.board
    assert board.grid["I9"] == "6"
  end
end
