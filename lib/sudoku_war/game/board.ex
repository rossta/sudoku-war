defmodule SudokuWar.Game.Board do
  require Logger

  @size 9

  defstruct [
    game_id: nil,
    grid: %{},
    ready: false,
  ]

  @doc """
  Finds or creates a new board for a Game
  """
  def find_or_create(game_id) do
    Logger.debug "Starting board for game #{game_id}"

    case GenServer.whereis(ref(game_id)) do
      nil ->
        create(game_id)
      board_pid ->
        {:ok, board_pid}
    end
  end

  @doc """
  Creates a new board for a Game
  """
  def create(game_id) do
    Agent.start(fn -> %__MODULE__{game_id: game_id, grid: build_grid} end, name: ref(game_id))
  end

  @doc """
  Returns the board
  """
  def get_data(game_id) do
    Agent.get(ref(game_id), &(&1))
  end

  # Builds a default grid map
  defp build_grid do
    for x <- 0..@size - 1,
        y <- 0..@size - 1,
        into: Map.new,
        do: {"#{x}#{y}", nil}
  end

  # Generates global reference name for the board process
  defp ref(game_id), do: {:global, {:board, game_id}}
end
