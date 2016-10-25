defmodule SudokuWar.PageController do
  use SudokuWar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
