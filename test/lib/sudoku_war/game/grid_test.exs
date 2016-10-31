defmodule SudokuWar.Game.GridTest do
  use ExUnit.Case, async: true
  alias SudokuWar.{Game.Grid}

  setup do
    {:ok, %{}}
  end

  test "create a empty board" do
    grid = Grid.new
    assert Enum.all? Map.values(grid), &Enum.empty?/1
  end

  test "create a board with default digists" do
    grid = Grid.new([1,2,3,4,5,6,7,8,9])
    assert Enum.all? Map.values(grid), &(&1 == [1,2,3,4,5,6,7,8,9])
  end

  test "squares" do
    squares = Grid.squares
    assert length(squares) == 81
    assert Enum.member?(squares, "00")
    assert Enum.member?(squares, "01")
    assert Enum.member?(squares, "02")

    # assert all(len(peers[s]) == 20 for s in squares)]
  end

  test "unit_list" do
    unit_list = Grid.unit_list
    assert length(unit_list) == 27
  end

  test "units" do
    units = Grid.units
    assert units["22"] == [
     ["02", "12", "22", "32", "42", "52", "62", "72", "82"],
     ["20", "21", "22", "23", "24", "25", "26", "27", "28"],
     ["00", "01", "02", "10", "11", "12", "20", "21", "22"]
   ]

   assert Enum.all?(Map.values(units), fn(u) -> length(u) == 3 end)
  end

  test "peers" do
    peers = Grid.peers
    assert peers["21"] == MapSet.new(["01", "11", "31", "41", "51", "61", "71", "81",
     "20", "22", "23", "24", "25", "26", "27", "28",
     "00", "02", "10", "12"])
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

    grid = Grid.parse_grid(text)
    assert grid["00"] == [2]
    assert grid["10"] == [1]
    assert grid["01"] == [6]
    assert grid["33"] == [1]
    assert grid["78"] == [1]
    assert grid["87"] == [5]

    values = Map.values(grid)
    assert length(values) == 81
    assert Enum.all?(values, fn([v]) -> Enum.member?(1..9, v) end)
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

    grid = Grid.parse_grid(text)
    assert grid["00"] == [2]
    assert grid["10"] == [1]
    assert grid["01"] == []
    assert grid["33"] == []
    assert grid["78"] == []
    assert grid["87"] == [5]

    values = Map.values(grid)
    assert length(values) == 81
  end

  test "assign all from whitespace text (easy)" do
    text = """
    2 0 8 7 0 9 3 0 5
    1 3 0 8 0 5 0 0 0
    0 0 9 0 6 4 0 0 2
    3 0 7 0 0 2 5 0 0
    0 0 0 0 5 0 7 1 0
    5 8 0 4 0 6 0 3 0
    8 0 5 0 4 1 9 0 3
    0 0 0 0 0 0 4 2 0
    4 1 3 0 9 0 0 0 6
    """

    grid = Grid.parse_grid(text) |> Grid.assign_all

    assert grid["00"] == [2]
    assert grid["10"] == [1]
    assert grid["01"] == [6]
    assert grid["33"] == [1]
    assert grid["78"] == [1]
    assert grid["87"] == [5]
  end

  test "assign all from stripped text (easy)" do
    text = "003020600900305001001806400008102900700000008006708200002609500800203009005010300"

    grid = Grid.parse_grid(text) |> Grid.assign_all

    assert grid["00"] == [4]
    assert grid["10"] == [9]
    assert grid["01"] == [8]
  end

  test "assign all from stripped text (hard)" do
    text = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"

    grid = Grid.parse_grid(text) |> Grid.assign_all

    assert grid["00"] == [4]
    assert grid["10"] == [2,6,7,8,9]
    assert grid["01"] == [1,6,7,9]
  end

  test "search from stripped text (hard)" do
    text = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"

    grid = Grid.parse_grid(text) |> Grid.assign_all |> Grid.search

    IO.puts ""
    Grid.puts(grid)
    IO.puts ""

    assert grid["00"] == [4]
    assert grid["10"] == [8]
    assert grid["01"] == [1]
  end
end
