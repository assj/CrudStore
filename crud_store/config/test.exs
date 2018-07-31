use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crud_store, CrudStore.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :crud_store, CrudStore.Repo,
  database: "crud_store_test",
  hostname: "localhost"
