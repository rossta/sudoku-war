defmodule SudokuWar.PlayerSocketTest do
  use SudokuWar.ChannelCase, async: true

  alias SudokuWar.{PlayerSocket}

  @id SudokuWar.generate_player_id

  setup do
    {:ok, socket} = connect(PlayerSocket, %{"id" => @id})

    {:ok, socket: socket}
  end

  test "assigns player", %{socket: socket} do
    assert socket.assigns.player_id == @id
  end

  test "assigns id", %{socket: socket} do
    assert socket.id == "player_socket:#{@id}"
  end
end
