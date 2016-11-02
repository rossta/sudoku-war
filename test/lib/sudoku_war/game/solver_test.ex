defmodule SudokuWar.Game.SolverTest do
  use ExUnit.Case

  alias SudokuWar.Game.{Solver,Grid}

  setup do
    {:ok, %{}}
  end

  def print(grid, solved) do
    IO.puts "puzzle-----------"
    Grid.display(grid)
    IO.puts "solved-----------"
    Grid.display(solved)
    IO.puts "\n"
  end

  test "solve easy" do
    grid1 = '..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3..'
    solved = Solver.solve(grid1)
    assert solved == '483921657967345821251876493548132976729564138136798245372689514814253769695417382'
    print(grid1, solved)
  end

  test "solve hard" do
    grid2 = '4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......'
    solved = Solver.solve(grid2)
    assert solved == '417369825632158947958724316825437169791586432346912758289643571573291684164875293'
    print(grid2, solved)
  end
end
