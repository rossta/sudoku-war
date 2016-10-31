defmodule SudokuWar.Game.Grid do
  require IEx
  @type t :: %{ optional(String.t) => integer }

  @size 9
  @indexes Enum.to_list 0..@size - 1
  @digits Enum.map(@indexes, &(&1 + 1))
  @digit_chars Enum.map(@digits, &to_string/1)
  @rows @indexes
  @cols @indexes
  @secs Enum.chunk(@indexes, 3)

  @spec new(nil | list) :: __MODULE__.t()
  def new([_|_] = values) when length(values) == @size*@size, do: Enum.zip(squares, values) |> Map.new
  def new(val \\ []) do
    for square <- squares, into: Map.new, do: {square, val}
  end

  def squares do
    cross(@rows, @cols)
  end

  def unit_list do
    (for c <- @cols, into: [], do: cross(@rows, c)) ++
    (for r <- @rows, into: [], do: cross(r, @cols)) ++
    (for rs <- @secs, cs <- @secs, into: [], do: cross(rs, cs))
  end

  def units do
    do_units(squares, unit_list, %{})
  end

  defp do_units([], unit_list, map), do: map
  defp do_units([square | rest], unit_list, map) do
    do_units(rest, unit_list, Map.put(map, square, Enum.filter(unit_list, &(Enum.member?(&1, square)))))
  end

  def peers do
    do_peers(squares, units, %{})
  end

  defp do_peers([], _units, map), do: map
  defp do_peers([square | rest], units, map) do
    unit_set = for unit <- units[square], item <- unit, into: MapSet.new, do: item
    square_set = MapSet.new([square])
    do_peers(rest, units, Map.put(map, square, MapSet.difference(unit_set, square_set)))
  end

  defp cross([_|_] = rows, [_|_] = cols) do
    for r <- rows,
        c <- cols,
        into: [],
        do: "#{r}#{c}"
  end
  defp cross([_|_] = rows, col), do: cross(rows, [col])
  defp cross(row, [_|_] = cols), do: cross([row], cols)

  def parse_grid(text) do
    Regex.replace(~r/\s+/, text, "")
    |> String.split("", trim: true)
    |> Enum.map(&parse_grid_value/1)
    |> new
  end

  defp parse_grid_value(value) when value in @digit_chars, do: parse_grid_value(String.to_integer(value))
  defp parse_grid_value(value) when value in @digits, do: [value]
  defp parse_grid_value(value), do: []

  @spec assign_all(__MODULE__.t|list) :: __MODULE__.t()
  def assign_all(%{} = grid) do
    assign_all(Map.to_list(grid), new(@digits))
  end
  def assign_all([], grid), do: grid
  def assign_all([first_pair|rest], grid) do
    assign_all(rest, assign(grid, first_pair))
  end

  def assign(grid, {square, [digit]}) do
    eliminate(grid, square, List.delete(grid[square], digit))
  end
  def assign(grid, {_square, _digits}), do: grid

  def eliminate(grid, [], _digit), do: grid
  def eliminate(grid, [square|rest], digit) do
    eliminate(grid, square, [digit]) |> eliminate(rest, digit)
  end
  def eliminate(grid, square, []), do: grid
  def eliminate(grid, square, [digit | digits]) do
    eliminate(grid, square, digit, grid[square]) |> eliminate(square, digits)
  end
  def eliminate(grid, square, digit, []), do: raise ArgumentError, message: "cannot eliminate empty digits"
  def eliminate(grid, square, digit, digits)  do
    case digit in digits do
      true ->
        Map.update!(grid, square, fn(digits) -> List.delete(digits, digit) end)
        |> eliminate_peers(square)
      false ->
        grid
    end
  end

  defp eliminate_peers(grid, square), do: eliminate_peers(grid, square, grid[square])
  defp eliminate_peers(grid, square, []), do: raise ArgumentError, message: "cannot eliminate peers with empty digits"
  defp eliminate_peers(grid, square, [digit]) do # square reduced to one value, remove digit from peers
    eliminate(grid, Enum.to_list(peers[square]), digit)
  end
  defp eliminate_peers(grid, _square, _digits), do: grid

  # def assign(grid, {square, []}), do: grid
  # def assign(grid, {square, [d | rest] = digits}) do
  #   assign(eliminate(grid, square, d), {square, rest})
  # end
  #
  # # Eliminate other digits from grid[square]
  # defp eliminate(grid, [], _digit), do: grid
  # defp eliminate(grid, [square|rest], digit) do
  #   eliminate(grid, square, digit) |> eliminate(rest, digit)
  # end
  # defp eliminate(grid, square, digit), do: eliminate(grid, square, digit, grid[square])
  # defp eliminate(grid, square, digit, digits) do
  #   case digit in digits do
  #     true ->
  #       Map.update!(grid, square, fn(digits) -> List.delete(digits, digit) end)
  #       |> eliminate_peers(square)
  #     false ->
  #       grid
  #   end
  # end
  #
  # defp eliminate_peers(grid, square), do: eliminate_peers(grid, square, grid[square])
  # defp eliminate_peers(_grid, _square, []), do: raise ArgumentError
  # defp eliminate_peers(grid, square, [digit]) do
  #   eliminate(grid, Enum.to_list(peers[square]), digit)
  # end
  # defp eliminate_peers(grid, _square, [_|_]), do: grid
end
