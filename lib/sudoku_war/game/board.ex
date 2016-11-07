defmodule SudokuWar.Game.Board do
  require Logger
  alias SudokuWar.Game.Grid

  @size 9

  @type t :: %__MODULE__{ grid: Grid.t }

  defstruct [
    game_id: nil,
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
    Logger.debug "Creating game #{game_id}"
    Agent.start(fn -> %__MODULE__{grid: build_grid, game_id: game_id} end, name: ref(game_id))
  end

  @doc """
  Returns the board
  """
  def get_data(game_id) do
    Agent.get(ref(game_id), &(&1))
  end

  def put_data(game_id, new_board) do
    Agent.update(ref(game_id), fn(_) -> new_board end)
  end

  def enter_value(game_id, {key, value}) do
    {_, board_data} = Map.get_and_update(get_data(game_id), :grid, fn current_grid ->
      { current_grid, Map.put(current_grid, key, value) }
    end)

    IO.inspect "board_data.grid[#{key}] " <> board_data.grid[key]

    put_data(game_id, board_data)

    IO.inspect "get_data[#{key}] " <> get_data(game_id).grid[key]

    board_data
  end

  def destroy(game_id) do
    case GenServer.whereis(ref(game_id)) do
      nil ->
        Logger.debug "Attempt to destroy unexisting Board for game #{game_id}"
      pid ->
        Logger.debug "Stopping board for game #{game_id}"

        Agent.stop(pid, :normal, :infinity)
    end
  end

  # Builds a default grid map
  defp build_grid do
    Grid.parse_grid('4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......')
  end

  # Generates global reference name for the board process
  defp ref(game_id), do: {:global, {:board, game_id}}
end
