defmodule SudokuWar.PageViewTest do
  use SudokuWar.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders index.html" do
    assert render_to_string(SudokuWar.PageView, "index.html", []) =~ "Welcome to Sudoku War"
  end
end
