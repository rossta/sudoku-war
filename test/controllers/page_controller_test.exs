defmodule SudokuWar.PageControllerTest do
  use SudokuWar.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Sudoku War"
  end
end
