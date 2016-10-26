defmodule LobbyTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "visit lobby" do
    navigate_to("/play")

    find_element(:class, "lobby-welcome") |> visible_text == "Let's play!"
  end
end
