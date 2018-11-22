defmodule EarthquakeTracker.TrackedEarthquakes.TrackedEarthquake do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tracked_earthquakes" do
    field :last_checked, :naive_datetime, null: false
    field :max_lat, :decimal, null: false
    field :max_lng, :decimal, null: false
    field :min_lat, :decimal, null: false
    field :min_lng, :decimal, null: false
    field :name, :string, null: false
    field :user_id, :id, null: false

    timestamps()
  end

  @doc false
  def changeset(tracked_earthquake, attrs) do
    tracked_earthquake
    |> cast(attrs, [:min_lat, :max_lat, :min_lng, :max_lng, :last_checked, :name, :user_id])
    |> validate_required([:min_lat, :max_lat, :min_lng, :max_lng, :name, :user_id])
    |> unique_constraint(:name_user_id, [{:message, "Tracked areas must have unique names"}])
  end
end
