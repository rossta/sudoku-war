defmodule SudokuWar.GameTest do
  use ExUnit.Case, async: true
  alias SudokuWar.{Game, Game.Board}
  alias SudokuWar.Game.Supervisor, as: GameSupervisor

  setup do
    id =  SudokuWar.generate_game_id
    attacker_id = SudokuWar.generate_player_id
    defender_id = SudokuWar.generate_player_id

    {:ok, id: id, attacker_id: attacker_id, defender_id: defender_id}
  end

  test "joining a game which does not exist" do
    assert {:error, "Game does not exist"} = Game.join("wrong-id", 1, self)
  end

  test "joining a game", %{id: id, attacker_id: attacker_id, defender_id: defender_id} do
    {:ok, pid} = GameSupervisor.create_game(id)

    another_player_id = SudokuWar.generate_player_id

    assert {:ok, ^pid} = Game.join(id, attacker_id, self)
    assert {:ok, ^pid} = Game.join(id, attacker_id, self)
    assert {:ok, ^pid} = Game.join(id, attacker_id, self)
    assert {:ok, ^pid} = Game.join(id, defender_id, self)
    assert {:ok, ^pid} = Game.join(id, defender_id, self)
    assert {:error, "No more players allowed"} = Game.join(id, another_player_id, self)

    game = Game.get_data(id)
    assert ^attacker_id = game.attacker
    assert ^defender_id = game.defender

    assert %Board{game_id: ^id} = Agent.get({:global, {:board, id}}, &(&1))
  end

  test "entering a grid value", %{id: id, attacker_id: attacker_id} do
    {:ok, pid} = GameSupervisor.create_game(id)
    assert {:ok, ^pid} = Game.join(id, attacker_id, self)

    game = Game.get_data(id)
    board = game.board

    assert board.grid["A1"] == "4"
    assert board.grid["A2"] == "0"

    Game.enter_value(id, {"A1", "6"})
    Game.enter_value(id, {"A2", "4"})

    game = Game.get_data(id)
    board = game.board

    assert board.grid["A1"] == "6"
    assert board.grid["A2"] == "4"
  end
end
