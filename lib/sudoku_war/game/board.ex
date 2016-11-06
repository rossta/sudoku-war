defmodule SudokuWar.Game.Board do
  require Logger
  alias SudokuWar.Game.Grid

  @size 9

  @type t :: %__MODULE__{ grid: Grid.t }

  defstruct [
    grid: nil,
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
    Agent.start(fn -> %__MODULE__{grid: build_grid} end, name: ref(game_id))
  end

  @doc """
  Returns the board
  """
  def get_data(game_id) do
    Agent.get(ref(game_id), &(&1))
  end

  def enter_value(game_id, {row, col, value}) do
    {_, board_data} = Map.get_and_update(get_data(game_id), :grid, fn current_grid ->
      { current_grid, Map.put(current_grid, "#{row}#{col}", value) }
    end)

    board_data
  end

  # Builds a default grid map
  defp build_grid do
    Grid.parse_grid('4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......')
  end

  # Generates global reference name for the board process
  defp ref(game_id), do: {:global, {:board, game_id}}
end
