defmodule EarthquakeTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :admin, :boolean, default: false, null: false
    field :email, :string, null: false
    field :password_hash, :string
    field :pw_last_try, :utc_datetime
    field :pw_tries, :integer, null: false, default: 0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :admin, :password_hash, :pw_tries, :pw_last_try])
    |> validate_required([:email, :admin, :password_hash, :pw_tries, :pw_last_try])
  end
end
