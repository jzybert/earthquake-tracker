defmodule EarthquakeTracker.TrackedEarthquakes do
  @moduledoc """
  The TrackedEarthquakes context.
  """

  import Ecto.Query, warn: false
  alias EarthquakeTracker.Repo

  alias EarthquakeTracker.TrackedEarthquakes.TrackedEarthquake

  @doc """
  Returns the list of tracked_earthquakes.

  ## Examples

      iex> list_tracked_earthquakes()
      [%TrackedEarthquake{}, ...]

  """
  def list_tracked_earthquakes do
    Repo.all(TrackedEarthquake)
  end

  @doc """
  Returns the list of tracked_earthquakes for some user.
  """
  def list_tracked_earthquakes_by_user(user_id) do
    Repo.all(from t in TrackedEarthquake, where: t.user_id == ^user_id)
  end

  @doc """
  Gets a single tracked_earthquake.

  Raises `Ecto.NoResultsError` if the Tracked earthquake does not exist.

  ## Examples

      iex> get_tracked_earthquake!(123)
      %TrackedEarthquake{}

      iex> get_tracked_earthquake!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tracked_earthquake!(id), do: Repo.get!(TrackedEarthquake, id)

  @doc """
  Creates a tracked_earthquake.

  ## Examples

      iex> create_tracked_earthquake(%{field: value})
      {:ok, %TrackedEarthquake{}}

      iex> create_tracked_earthquake(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tracked_earthquake(attrs \\ %{}) do
    %TrackedEarthquake{}
    |> TrackedEarthquake.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tracked_earthquake.

  ## Examples

      iex> update_tracked_earthquake(tracked_earthquake, %{field: new_value})
      {:ok, %TrackedEarthquake{}}

      iex> update_tracked_earthquake(tracked_earthquake, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tracked_earthquake(%TrackedEarthquake{} = tracked_earthquake, attrs) do
    tracked_earthquake
    |> TrackedEarthquake.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TrackedEarthquake.

  ## Examples

      iex> delete_tracked_earthquake(tracked_earthquake)
      {:ok, %TrackedEarthquake{}}

      iex> delete_tracked_earthquake(tracked_earthquake)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tracked_earthquake(%TrackedEarthquake{} = tracked_earthquake) do
    Repo.delete(tracked_earthquake)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tracked_earthquake changes.

  ## Examples

      iex> change_tracked_earthquake(tracked_earthquake)
      %Ecto.Changeset{source: %TrackedEarthquake{}}

  """
  def change_tracked_earthquake(%TrackedEarthquake{} = tracked_earthquake) do
    TrackedEarthquake.changeset(tracked_earthquake, %{})
  end
end
