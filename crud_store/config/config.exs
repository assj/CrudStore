# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :crud_store,
  ecto_repos: [CrudStore.Repo]

# Configures the endpoint
config :crud_store, CrudStore.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dtsJU5M+n/tnWT/LpbIPZbzkKPqjcA8pvbPtpkUMXKsu6+hFnQVsOR3VJhedRSFf",
  render_errors: [view: CrudStore.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CrudStore.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :exredis,
  host: "localhost",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
