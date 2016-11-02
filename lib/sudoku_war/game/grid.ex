defmodule SudokuWar.Game.Grid do
  alias __MODULE__

  @size 9
  @rows 'ABCDEFGHI'
  @cols '123456789'
  @digits '123456789'

  @type t :: %Grid{ values: map, squares: list, units: map, peers: map }
  # used to cache all squares, units, and peer relationships
  defstruct values: nil, squares: nil, units: nil, peers: nil

  @doc """
  Convert grid into a Map of {square: char} with '0' or '.' for empties.
  """
  @spec new(nil | list) :: Grid.t()
  def new do
    %Grid{squares: squares, units: units, peers: peers, values: all_values([]) }
  end
  def new([_|_] = chars) when length(chars) == @size*@size do
    %{new | values: grid_values(chars)}
  end
  def new(text) when is_binary(text) do
    Regex.replace(~r/\s+/, text, "")
    |> to_char_list
    |> new
  end

  @doc """
  Convert grid into a Map of {square: char} with '0' or '.' for empties.
  """
  def grid_values(grid) do
    digits = for d <- grid, d in @digits or d in '0.', do: d
    unless length(digits) == @size*@size, do: raise("Expected number of grid cells is #{@size*@size}")
    Enum.zip(squares, digits) |> Enum.into(%{})
  end

  @doc "Return all squares"
  def squares, do: cross(@rows, @cols)

  @doc """
  All squares divided by row, column, and box.
  """
  def unit_list do
    (for c <- @cols, do: cross(@rows, [c])) ++
    (for r <- @rows, do: cross([r], @cols)) ++
    (for rs <- Enum.chunk(@rows, 3), cs <- Enum.chunk(@cols, 3), do: cross(rs, cs))
  end

  @doc """
  All squares from unit_list, organized in a Map with each square as key.

  Map.get(SudokuSolver.units, 'C2')
  [['A2', 'B2', 'C2', 'D2', 'E2', 'F2', 'G2', 'H2', 'I2'],
  ['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9'],
  ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']]
  """
  def units do
    for sq <- squares,
    into: %{},
    do: {sq, (for ul <- unit_list, sq in ul, do: ul)}
  end

  @doc """
  Like units/0 above, returning a Map, but not including the key itself.

  Map.get(SudokuSolver.peers, 'C2')
  MapSet.new(['A2', 'B2', 'D2', 'E2', 'F2', 'G2', 'H2', 'I2',
  'C1', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9',
  'A1', 'A3', 'B1', 'B3'])
  """
  def peers do
    for sq <- squares, into: %{}, do: {sq, peers(sq)}
  end
  def peers(square) do
    unit_set = units[square] |> Enum.concat |> Enum.into(MapSet.new)
    square_set = [square] |> Enum.into(MapSet.new)
    MapSet.difference(unit_set, square_set)
  end

  @doc """
  Generate a values Map with every possible value.
  """
  def all_values do
    all_values(@digits)
  end
  def all_values(val) do
    for sq <- squares, into: %{}, do: {sq, val}
  end

  @doc """
  Flatten a values Map back into a single char list.
  """
  def flatten(values, board) do
    board.squares
    |> Enum.map(&(values[&1]))
    |> Enum.concat
  end

  @doc """
  Parse grid values from text
  """
  def parse_grid(text) do
    new(text)
  end

  @doc """
  Display these values as a 2-D grid.
  """
  def display(grid) do
    Enum.chunk(grid, @size)
    |> Enum.map(fn row -> Enum.chunk(row, 1) |> Enum.join(" ") end)
    |> Enum.join("\n")
    |> IO.puts
  end

  defp cross([_|_] = rows, [_|_] = cols) do
    for r <- rows, c <- cols, do: [r] ++ [c]
  end
end
