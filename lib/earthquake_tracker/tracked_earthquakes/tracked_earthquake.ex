defmodule EarthquakeTracker.TrackedEarthquakes.TrackedEarthquake do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tracked_earthquakes" do
    field :last_checked, :naive_datetime
    field :max_lat, :decimal
    field :max_lng, :decimal
    field :min_lat, :decimal
    field :min_lng, :decimal
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(tracked_earthquake, attrs) do
    tracked_earthquake
    |> cast(attrs, [:min_lat, :max_lat, :min_lng, :max_lng, :last_checked, :name, :user_id])
    |> validate_required([:min_lat, :max_lat, :min_lng, :max_lng, :name, :user_id])
  end
end
