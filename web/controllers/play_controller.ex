defmodule SudokuWar.PlayController do
  use SudokuWar.Web, :controller
  require Logger

  plug :put_layout, "play.html"

  def index(conn, _params) do
    player_id = case get_session(conn, :player_id) do
      nil -> SudokuWar.generate_player_id
      id -> id
    end

    conn = put_session(conn, :player_id, player_id)

    render conn, "index.html", id: player_id
  end
end
