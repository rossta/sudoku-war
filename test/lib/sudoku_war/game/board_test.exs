defmodule SudokuWar.BoardTest do
  use ExUnit.Case, async: true
  alias SudokuWar.{Game.Board}

  setup do
    {:ok, game_id: "abcd1234"}
  end

  test "create a board with map grid", %{game_id: game_id} do
    {:ok, _board_pid} = Board.create(game_id)

    board = Board.get_data(game_id)

    keys = Map.keys(board.grid)
    assert 81 = length(keys)
    assert Enum.member?(keys, "00")
    assert Enum.member?(keys, "01")
    assert Enum.member?(keys, "02")
  end
end
