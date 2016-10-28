defmodule StartGameTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "start new game" do
    navigate_to("/play")

    click({:link_text, "Start new game"})

    assert visible_page_text =~ "Set up board"

    assert element_displayed?({:css, ".board"})
    assert element_displayed?({:css, ".board .row:nth-child(1) .cell:nth-child(1)"})
    assert element_displayed?({:css, ".board .row:nth-child(9) .cell:nth-child(9)"})
  end
end
