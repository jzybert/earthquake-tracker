defmodule EarthquakeTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :admin, :boolean, default: false, null: false
      add :password_hash, :string
      add :pw_tries, :integer, null: false, default: 0
      add :pw_last_try, :utc_datetime
      add :email_notifications, :boolean, default: false, null: false

      timestamps()
    end

    create index(:users, [:email], unique: true)
  end
end
