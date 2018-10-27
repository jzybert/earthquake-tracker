defmodule EarthquakeTracker.Repo do
  use Ecto.Repo,
    otp_app: :earthquake_tracker,
    adapter: Ecto.Adapters.Postgres
end
