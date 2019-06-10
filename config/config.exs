# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :metrics,
  ecto_repos: [Metrics.Repo]

# Configures the endpoint
config :metrics, MetricsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hFS8lQAmzhL/U5vG1cfAU8R9nbJhxa+g9c3tVaBJC8QUbqnrpBD38uZl3XVknrJM",
  render_errors: [view: MetricsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Metrics.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :metrics, :enable_rsvp_importer, true
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
