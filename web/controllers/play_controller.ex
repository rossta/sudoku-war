defmodule SudokuWar.PlayController do
  use SudokuWar.Web, :controller

  plug :put_layout, "play.html"

  def index(conn, _params) do
    render conn, "index.html", id: SudokuWar.generate_player_id
  end
end
