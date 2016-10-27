defmodule SudokuWarTest do
  use ExUnit.Case, async: true

  test "generate_player_id" do
    player_1_id = SudokuWar.generate_player_id
    player_2_id = SudokuWar.generate_player_id
    refute player_1_id == player_2_id
    assert 8 = String.length(player_1_id)
    assert 8 = String.length(player_2_id)
  end
end
