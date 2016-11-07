defmodule SudokuWar.BoardTest do
  use ExUnit.Case, async: true
  alias SudokuWar.{Game.Board}

  @game_id 4 |> :crypto.strong_rand_bytes |> Base.encode64()

  setup do
    {:ok, board} = Board.create(@game_id)

    on_exit fn ->
      Board.destroy(@game_id)
    end

    {:ok, game_id: @game_id, board: board}
  end

  test "create a board with map grid", %{game_id: game_id} do
    board = Board.get_data(game_id)

    keys = Map.keys(board.grid)
    assert 81 = length(keys)
    assert Enum.member?(keys, "A3")
    assert Enum.member?(keys, "B2")
    assert Enum.member?(keys, "C1")
  end

  test "enter value for board grid", %{game_id: game_id} do
    board = Board.get_data(game_id)

    assert board.grid["A1"] == "4"
    assert board.grid["A2"] == "0"

    Board.enter_value(game_id, {"A1", "6"})
    Board.enter_value(game_id, {"A2", "4"})

    board = Board.get_data(game_id)

    assert board.grid["A1"] == "6"
    assert board.grid["A2"] == "4"
  end
end
