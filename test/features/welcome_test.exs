defmodule WelcomeTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "welcome" do
    navigate_to("/")

    assert page_title() == "Sudoku War!"
  end
end
