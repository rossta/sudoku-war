# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sudoku_war,
  ecto_repos: [SudokuWar.Repo]

# Configures the endpoint
config :sudoku_war, SudokuWar.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Kqe9dD2AEO6IyGUtag+LlIAwYYdUU7h6lLpk8FoGHbkQfkn4IfCigvEloB8sPpWr",
  render_errors: [view: SudokuWar.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SudokuWar.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
