defmodule SudokuWar.Game.Solver do
  @moduledoc """
  Solves 9x9 Sudoku puzzles, Peter Norvig style.
  http://norvig.com/sudoku.html
  """
  alias SudokuWar.Game.Grid

  defmodule World do
    @type t :: %World{ squares: list, units: map, peers: map }

    defstruct squares: nil, units: nil, peers: nil

    def new do
      %World{squares: Grid.squares, units: Grid.units, peers: Grid.peers }
    end
  end

  @doc """
  Convert grid to a Map of possible values, {square: digits}, or
  return false if a contradiction is detected.
  """
  def parse_world(values, world) do
    # To start, every square can be any digit; then assign values from the world.
    values
    |> possible_values
    |> do_parse_grid(Enum.to_list(values), world)
  end

  defp do_parse_grid(values, [], _), do: values
  defp do_parse_grid(values, [{_square, value} | rest], grid) when value in '0.' do
    do_parse_grid(values, rest, grid)
  end

  defp do_parse_grid(values, [{square, value} | rest], world) do
    do_parse_grid(values, rest, world)
    |> assign(square, value, world)
  end

  @doc """
  Eliminate all the other values (except d) from values[s] and propagate.
  Return values, except return false if a contradiction is detected.
  """
  def assign(values, square, digit, world) do
    values = Map.put(values, square, [digit])
    peers = Enum.to_list(world.peers[square])
    eliminate(values, peers, [digit], world)
  end

  @doc """
  Eliminate values from given squares and propagate.
  """
  def eliminate(values, squares, vals_to_remove, world) do
    propagate squares, values, fn square, values ->
      eliminate_from_square(values, square, vals_to_remove, world)
    end
  end

  # Remove value(s) from a square, then:
  # (1) If a square s is reduced to one value, then eliminate it from the peers.
  # (2) If a unit u is reduced to only one place for a value d, then put it there.
  defp eliminate_from_square(values, square, vals_to_remove, world) do
    vals = values[square]
    vals_set = MapSet.new(vals)
    vals_to_remove_set = MapSet.new(vals_to_remove)
    if MapSet.intersection(vals_set, vals_to_remove_set) |> Enum.any? do
      vals = MapSet.difference(vals_set, vals_to_remove_set) |> Enum.into([])
      values = eliminate_peers(%{values | square => vals}, square, vals, world)
      eliminate_from_units(values, world.units[square], vals_to_remove, world)
    else
      values
    end
  end

  def eliminate_peers(_, _, vals, _) when length(vals) == 0, do: false
  def eliminate_peers(values, square, vals, world) when length(vals) == 1 do
    eliminate(values, Enum.to_list(world.peers[square]), vals, world)
  end
  def eliminate_peers(values, _, _, _), do: values

  # If a unit u is reduced to only one place for a value d, then put it there.
  defp eliminate_from_units(values, units, vals_to_remove, world) do
    propagate units, values, fn unit, values ->
      propagate vals_to_remove, values, fn val, values ->
        dplaces = for sq <- unit, val in values[sq], do: sq
        case length(dplaces) do
          0 -> false                                      # contradiction: no place for this value
          1 -> assign(values, Enum.at(dplaces, 0), val, world) # d can only be in one place in unit; assign it there
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
    values = Grid.new(chars)
    world = World.new

    values
    |> parse_world(world)
    |> search(world)
    |> Grid.flatten(world)
  end

  @doc """
  Using depth-first search and propagation, try all possible values.
  """
  def search(false, _), do: false
  def search(values, world) do
    case search_complete?(values) do
      true ->
        values # solved!
      false ->
        square_to_search(values) |> search_square(values, world)
    end
  end

  defp search_complete?(values) do
    Enum.all?(values, fn {_sq, ds} -> length(ds) == 1 end)
  end

  # Choose the unfilled square s with the fewest possibilities
  defp square_to_search(values) do
    unsolved_world = for {sq, ds} <- values, length(ds) > 1, do: {sq, ds}
    {square, _digits} = Enum.min_by(unsolved_world, fn {_sq, ds} -> length(ds) end)
    square
  end

  defp search_square(square, values, world) do
    Enum.find_value Map.get(values, square), fn d ->
      assign(values, square, d, world) |> search(world)
    end
  end

  defp possible_values(values) do
    Map.merge(Grid.all_values, values, fn _k, v1, v2 ->
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
