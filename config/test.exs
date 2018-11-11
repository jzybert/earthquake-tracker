use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :earthquake_tracker, EarthquakeTrackerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

get_secret = fn name ->
  base = Path.expand("~/.config/earthquake_tracker")
  File.mkdir_p!(base)
  path = Path.join(base, name)
  unless File.exists?(path) do
    secret = Base.encode16(:crypto.strong_rand_bytes(32))
    File.write!(path, secret)
  end
  String.trim(File.read!(path))
end

# Configure your database
config :earthquake_tracker, EarthquakeTracker.Repo,
  username: "earthquake_tracker",
  password: get_secret.("db_pass_test"),
  database: "earthquake_tracker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
