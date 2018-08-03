# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :store_mailer,
  ecto_repos: [StoreMailer.Repo]

# Configures the endpoint
config :store_mailer, StoreMailer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "heoh9ejXJVFmOfaPJQaaM1cN6y4JIpuiSxsJ/ogACilRhhn1HGvi7YxxH2qlDRZr",
  render_errors: [view: StoreMailer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StoreMailer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures mailer
config :store_mailer, StoreMailer.Mailer, adapter: Swoosh.Adapters.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
