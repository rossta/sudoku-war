defmodule SudokuWar.GameTest do
  use ExUnit.Case, async: true

  setup do
    id =  SudokuWar.generate_game_id
    attacker_id = SudokuWar.generate_player_id
    defender_id = SudokuWar.generate_player_id

    {:ok, id: id, attacker_id: attacker_id, defender_id: defender_id}
  end
end
