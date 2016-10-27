defmodule SudokuWar.LobbyChannelTest do
  use SudokuWar.ChannelCase

  alias SudokuWar.LobbyChannel

  setup do
    {:ok, _, socket} =
      socket("player_id", %{some: :assign})
      |> subscribe_and_join(LobbyChannel, "lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "current_games replies with list of games", %{socket: socket} do
    ref = push socket, "current_games"
    assert_reply ref, :ok, %{games: []}
  end

  test "new_game replies with new game id", %{socket: socket} do
    ref = push socket, "new_game"
    assert_reply ref, :ok, %{game_id: game_id}
    assert 8 = String.length(game_id)
  end
  #
  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
