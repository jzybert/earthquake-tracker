use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :earthquake_tracker, EarthquakeTrackerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :earthquake_tracker, EarthquakeTracker.Repo,
  username: "postgres",
  password: "postgres",
  database: "earthquake_tracker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
