defmodule SudokuWar.PlayControllerTest do
  use SudokuWar.ConnCase, async: true

  test "GET /play", %{conn: conn} do
    conn = get conn, "/play"
    assert html_response(conn, 200)
  end
end
