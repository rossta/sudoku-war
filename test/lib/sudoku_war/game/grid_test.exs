defmodule SudokuWar.Game.GridTest do
  use ExUnit.Case, async: true
  alias SudokuWar.{Game.Grid}

  setup do
    {:ok, %{}}
  end

  test "create a empty board" do
    grid = Grid.new
    assert Enum.all? Map.values(grid.values), &Enum.empty?/1
  end

  test "squares" do
    squares = Grid.squares
    assert length(squares) == 81
    assert Enum.member?(squares, 'A1')
    assert Enum.member?(squares, 'A2')
    assert Enum.member?(squares, 'B3')
  end

  test "unit_list" do
    unit_list = Grid.unit_list
    assert length(unit_list) == 27
  end

  test "units" do
    units = Grid.units
    assert units['C3'] == [
     ['A3', 'B3', 'C3', 'D3', 'E3', 'F3', 'G3', 'H3', 'I3'],
     ['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9'],
     ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']
   ]

   assert Enum.all?(Map.values(units), fn(u) -> length(u) == 3 end)
  end

  test "peers" do
    peers = Grid.peers
    assert peers['A2'] == MapSet.new(['A1', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3', 'D2', 'E2', 'F2', 'G2', 'H2', 'I2'])
  end

  test "parse full grid" do
    text = """
    2 6 8 7 1 9 3 4 5
    1 3 4 8 2 5 6 9 7
    7 5 9 3 6 4 1 8 2
    3 9 7 1 8 2 5 6 4
    6 4 2 9 5 3 7 1 8
    5 8 1 4 7 6 2 3 9
    8 2 5 6 4 1 9 7 3
    9 7 6 5 3 8 4 2 1
    4 1 3 2 9 7 8 5 6
    """

    grid = Grid.new(text)
    values = grid.values
    assert [values['A1']] == '2'
    assert [values['B1']] == '1'
    assert [values['A2']] == '6'
    assert [values['D4']] == '1'
    assert [values['G9']] == '3'
    assert [values['I8']] == '5'

    values = Map.values(values)
    assert length(values) == 81
    assert Enum.all?(values, fn(v) -> Enum.member?('123456789', v) end)
  end

  test "parse partial grid" do
    text = """
    2 0 8 7 0 9 3 0 5
    1 3 0 8 0 5 0 0 0
    0 0 9 0 6 4 0 0 2
    3 0 7 0 0 2 5 0 0
    0 0 0 0 5 0 7 1 8
    5 8 0 4 0 6 0 3 0
    8 0 5 0 4 1 9 0 3
    0 0 0 0 0 0 4 2 0
    4 1 3 0 9 0 8 5 6
    """

    grid = Grid.new(text)
    values = grid.values
    assert [values['A1']] == '2'
    assert [values['B1']] == '1'
    assert [values['A2']] == '0'
    assert [values['D4']] == '0'
    assert [values['G9']] == '3'
    assert [values['I8']] == '5'

    values = Map.values(values)
    assert length(values) == 81
  end
end
