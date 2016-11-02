defmodule SudokuWar.Game.Solver do
  @moduledoc """
  Solves 9x9 Sudoku puzzles, Peter Norvig style.
  http://norvig.com/sudoku.html
  """
  alias SudokuWar.Game.Grid

  @doc """
  Convert grid to a Map of possible values, {square: digits}, or
  return false if a contradiction is detected.
  """
  def parse_grid(grid) do
    # To start, every square can be any digit; then assign values from the grid.
    possible_values(grid)
    |> do_parse_grid(Enum.to_list(grid.values), grid)
  end

  defp do_parse_grid(values, [], _), do: values
  defp do_parse_grid(values, [{_square, value} | rest], grid) when value in '0.' do
    do_parse_grid(values, rest, grid)
  end

  defp do_parse_grid(values, [{square, value} | rest], grid) do
    do_parse_grid(values, rest, grid)
    |> assign(square, value, grid)
  end

  @doc """
  Eliminate all the other values (except d) from values[s] and propagate.
  Return values, except return false if a contradiction is detected.
  """
  def assign(values, square, digit, grid) do
    values = Map.put(values, square, [digit])
    peers = Enum.to_list(grid.peers[square])
    eliminate(values, peers, [digit], grid)
  end

  @doc """
  Eliminate values from given squares and propagate.
  """
  def eliminate(values, squares, vals_to_remove, grid) do
    propagate squares, values, fn square, values ->
      eliminate_from_square(values, square, vals_to_remove, grid)
    end
  end

  # Remove value(s) from a square, then:
  # (1) If a square s is reduced to one value, then eliminate it from the peers.
  # (2) If a unit u is reduced to only one place for a value d, then put it there.
  defp eliminate_from_square(values, square, vals_to_remove, grid) do
    vals = values[square]
    vals_set = MapSet.new(vals)
    vals_to_remove_set = MapSet.new(vals_to_remove)
    if MapSet.intersection(vals_set, vals_to_remove_set) |> Enum.any? do
      vals = MapSet.difference(vals_set, vals_to_remove_set) |> Enum.into([])
      values = eliminate_peers(%{values | square => vals}, square, vals, grid)
      eliminate_from_units(values, grid.units[square], vals_to_remove, grid)
    else
      values
    end
  end

  def eliminate_peers(_, _, vals, _) when length(vals) == 0, do: false
  def eliminate_peers(values, square, vals, grid) when length(vals) == 1 do
    eliminate(values, Enum.to_list(grid.peers[square]), vals, grid)
  end
  def eliminate_peers(values, _, _, _), do: values

  # If a unit u is reduced to only one place for a value d, then put it there.
  defp eliminate_from_units(values, units, vals_to_remove, grid) do
    propagate units, values, fn unit, values ->
      propagate vals_to_remove, values, fn val, values ->
        dplaces = for sq <- unit, val in values[sq], do: sq
        case length(dplaces) do
          0 -> false                                      # contradiction: no place for this value
          1 -> assign(values, Enum.at(dplaces, 0), val, grid) # d can only be in one place in unit; assign it there
          _ -> values
        end
      end
    end
  end

  @doc """
  Given a puzzle char list, find the solution and return as a char list.
  Use display/1 to print the grid as a square.
  """
  def solve([_|_] = chars) do
    grid = Grid.new(chars)
    parse_grid(grid)
    |> search(grid)
    |> Grid.flatten(grid)
  end

  @doc """
  Using depth-first search and propagation, try all possible values.
  """
  def search(false, _), do: false
  def search(values, grid) do
    case search_complete?(values) do
      true ->
        values # solved!
      false ->
        square_to_search(values) |> search_square(values, grid)
    end
  end

  defp search_complete?(values) do
    Enum.all?(values, fn {_sq, ds} -> length(ds) == 1 end)
  end

  # Choose the unfilled square s with the fewest possibilities
  defp square_to_search(values) do
    unsolved_grid = for {sq, ds} <- values, length(ds) > 1, do: {sq, ds}
    {square, _digits} = Enum.min_by(unsolved_grid, fn {_sq, ds} -> length(ds) end)
    square
  end

  defp search_square(square, values, grid) do
    Enum.find_value Map.get(values, square), fn d ->
      assign(values, square, d, grid) |> search(grid)
    end
  end

  defp possible_values(grid) do
    Map.merge(Grid.all_values, grid.values, fn _k, v1, v2 ->
      if v2 in '.0', do: v1, else: [v2]
    end)
  end

  defp propagate(_values, false, _fun), do: false
  defp propagate(_values, :contradiction, _fun), do: false
  defp propagate([], acc, _fun), do: acc
  defp propagate([first | rest], acc, fun) do
    propagate rest, fun.(first, acc), fun
  end

end
