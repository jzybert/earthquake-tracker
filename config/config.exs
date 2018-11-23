# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :earthquake_tracker,
  ecto_repos: [EarthquakeTracker.Repo]

# Configures the endpoint
config :earthquake_tracker, EarthquakeTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "H9BIV7Ofe4ca2P3ajdyjIWmM1W8XrBRZNuC4PE8OuEsgyUw3xjRGyi1kMG0gykVe",
  render_errors: [view: EarthquakeTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EarthquakeTracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

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

config :earthquake_tracker, EarthquakeTracker.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "email-smtp.us-east-1.amazonaws.com",
  port: 25,
  username: get_secret.("smtp_username"),
  password: get_secret.("smtp_password"),
  tls: :if_available,
  ssl: false,
  retries: 1
