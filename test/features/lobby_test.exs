defmodule LobbyTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "visit lobby" do
    navigate_to("/play")

    header = find_element(:class, "lobby-welcome") |> visible_text

    assert header =~ "Let's play!"

    # display games
  end
end
