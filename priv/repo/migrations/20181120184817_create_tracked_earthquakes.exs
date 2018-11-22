defmodule EarthquakeTracker.Repo.Migrations.CreateTrackedEarthquakes do
  use Ecto.Migration

  def change do
    create table(:tracked_earthquakes) do
      add :name, :string, null: false
      add :min_lat, :decimal, null: false
      add :max_lat, :decimal, null: false
      add :min_lng, :decimal, null: false
      add :max_lng, :decimal, null: false
      add :min_mag, :decimal
      add :max_mag, :decimal
      add :last_checked, :naive_datetime, null: false, default: fragment("NOW()")
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tracked_earthquakes, [:user_id])
    create index(:tracked_earthquakes, [:name, :user_id], unique: true)
  end
end
