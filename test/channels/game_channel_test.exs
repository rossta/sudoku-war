defmodule SudokuWar.GameChannelTest do
  use SudokuWar.ChannelCase

  alias SudokuWar.GameChannel

  setup do
    {:ok, _, socket} =
      socket("player_id", %{some: :assign})
      |> subscribe_and_join(GameChannel, "game:abcd1234")

    {:ok, socket: socket}
  end

  test "player joined game", %{socket: socket} do
    game_id = socket.assigns.game_id

    assert 8 = String.length(game_id)
  end

  # test "shout broadcasts to game:lobby", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end
  #
  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
