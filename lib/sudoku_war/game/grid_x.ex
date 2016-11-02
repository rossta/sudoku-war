defmodule SudokuWar.Game.GridX do
  require IEx
  @type t :: %{ optional(String.t) => integer }

  @size 9
  @sec_size round(:math.sqrt(@size))
  @indexes Enum.to_list 0..@size - 1
  @digits Enum.map(@indexes, &(&1 + 1))
  @digit_chars Enum.map(@digits, &to_string/1)
  @rows @indexes
  @cols @indexes
  @secs Enum.chunk(@indexes, 3)

  @spec new(nil | list) :: __MODULE__.t()
  def new(val \\ [])
  def new([_|_] = values) when length(values) == @size*@size, do: Enum.zip(squares, values) |> Map.new
  def new(val) do
    for square <- squares, into: Map.new, do: {square, val}
  end

  def squares do
    cross(@rows, @cols)
  end

  def unit_list do
    (for c <- @cols, do: cross(@rows, c)) ++
    (for r <- @rows, do: cross(r, @cols)) ++
    (for rs <- @secs, cs <- @secs, do: cross(rs, cs))
  end

  def units do
    for sq <- squares, do: {sq, (for u <- unit_list, sq in u, do: u)}
    |> Enum.into(%{})
  end

  def peers do
    for sq <- squares do
      unit_set = units[sq] |> Enum.concat |> Enum.into(MapSet.new)
      square_set = MapSet.new([sq])

      {sq, MapSet.difference(unit_set, square_set)}
    end
    |> Enum.into(%{})
  end

  # def peers do
  #   do_peers(squares, units, %{})
  # end
  #
  # defp do_peers([], _units, map), do: map
  # defp do_peers([square | rest], units, map) do
  #   unit_set = for unit <- units[square], item <- unit, into: MapSet.new, do: item
  #   square_set = MapSet.new([square])
  #   do_peers(rest, units, Map.put(map, square, MapSet.difference(unit_set, square_set)))
  # end

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
  defp parse_grid_value(_value), do: []

  @spec assign_all(__MODULE__.t|list) :: __MODULE__.t()
  def assign_all(%{} = grid) do
    assign_all(Map.to_list(grid), new(@digits))
  end
  def assign_all([], grid), do: grid
  def assign_all([{square, digits}|rest], grid) do
    assign_all(rest, assign(grid, square, digits))
  end

  def assign(grid, square, [digit]) do
    eliminate(grid, square, List.delete(grid[square], digit))
  end
  def assign(grid, _square, []), do: grid
  def assign(grid, _square, [_|_]), do: grid
  def assign(grid, square, digit), do: assign(grid, square, [digit])

  def eliminate(grid, [], _digit), do: grid
  def eliminate(grid, [square|rest], digit) do
    case eliminate(grid, square, [digit]) do
      {:contradiction, _msg} = contradiction ->
        contradiction
      new_grid ->
        eliminate(new_grid, rest, digit)
    end
  end
  def eliminate(grid, _square, []), do: grid
  def eliminate(grid, square, [digit | digits]) do
    case eliminate(grid, square, digit, grid[square]) do
      {:contradiction, _msg} = contradiction ->
        contradiction
      new_grid ->
        eliminate(new_grid, square, digits)
    end
  end
  def eliminate(_grid, square, _digit, []), do: { :contradiction, "encountered empty square #{square}" }
  def eliminate(grid, square, digit, digits)  do
    case digit in digits do
      true ->
        Map.update!(grid, square, fn(digits) -> List.delete(digits, digit) end)
        |> eliminate_peers(square)
        |> assign_units(square, digit)
      false ->
        grid
    end
  end

  # If a square is reduced to one digit, then eliminate digit from the peers.
  defp eliminate_peers(grid, square), do: eliminate_peers(grid, square, grid[square])
  defp eliminate_peers(_grid, square, []), do: { :contradiction, "removed last value in square #{square}" }
  defp eliminate_peers(grid, square, [digit]) do
    eliminate(grid, Enum.to_list(peers[square]), digit)
  end
  defp eliminate_peers(grid, _square, _digits), do: grid

  # If a unit u is reduced to only one place for a digit, then put it there.
  defp assign_units({:contradiction, _} = contradiction, _, _, _), do: contradiction
  defp assign_units(grid, square, digit), do: assign_units(grid, square, digit, units[square])
  defp assign_units(grid, square, digit, []), do: grid
  defp assign_units(grid, square, digit, [unit | rest]) do
    squares = for sq <- unit, digit in grid[sq], do: sq
    case assign_squares(grid, squares, digit) do
      {:contradiction, _msg} = contradiction ->
        contradiction
      new_grid ->
        assign_units(new_grid, square, digit, rest)
    end
  end

  defp assign_squares(grid, [], digit), do: { :contradiction, "no place for digit #{digit}" }
  defp assign_squares(grid, [square], digit), do: assign(grid, square, digit)
  defp assign_squares(grid, [_|_], digit), do: grid

  def search({:contradiction, _msg} = contradiction), do: contradiction
  def search(grid) do
    case complete?(grid) do
      true ->
        grid
      false ->
        unsolved_grid = for {sq, ds} <- grid, length(ds) > 1, do: {sq, ds}
        {square, _digits} = Enum.min_by(unsolved_grid, fn {_sq, ds} -> length(ds) end)

        search(grid, square)
    end
  end

  def search(grid, square), do: search(grid, square, grid[square])
  def search(grid, square, []), do: grid
  def search(grid, square, [digit|rest]) do
    case search(assign(grid, square, digit)) do
      {:contradiction, msg} ->
        search(grid, square, rest)
      new_grid ->
        new_grid
    end
  end

  defp complete?(grid) do
    Enum.all?(grid, fn {_sq, ds} -> length(ds) == 1 end)
  end

  def print(grid), do: __MODULE__.puts(grid)
  def puts(grid) do
    width = Enum.max(for {sq, ds} <- grid, do: length(ds))
    line = Enum.join((for n <- 1..3, do: String.duplicate("-", width*3)), "+")

    breakpoints = Enum.chunk(@indexes, @sec_size) |> Enum.map(&Enum.max/1) |> Enum.take(@sec_size-1) # [2, 5]
    for r <- @rows do
      text = for c <- @cols do
        (Enum.join(grid["#{r}#{c}"], "") |> String.pad_trailing(width)) <> (if c in breakpoints, do: "|", else: "")
      end
      IO.puts Enum.join text, ""
      if r in breakpoints, do: IO.puts line
    end
  end
end
