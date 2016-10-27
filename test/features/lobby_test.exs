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

  test "start new game" do
    navigate_to("/play")

    click({:link_text, "Start new game"})

    assert visible_page_text =~ "Set up board"
  end
end
