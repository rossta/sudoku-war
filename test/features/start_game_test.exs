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

  @tag :skip
  test "refresh game page" do
    navigate_to("/play")

    click({:link_text, "Start new game"})

    game_page = current_path
    assert visible_page_text =~ "Set up board"
    take_screenshot("test1.png")
    refresh_page
    take_screenshot("test2.png")
    assert visible_page_text =~ "Set up board"
    assert game_page == current_path
  end
end
