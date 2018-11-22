defmodule EarthquakeTrackerWeb.TrackedEarthquakeController do
  use EarthquakeTrackerWeb, :controller

  alias EarthquakeTracker.TrackedEarthquakes
  alias EarthquakeTracker.TrackedEarthquakes.TrackedEarthquake

  def index(conn, %{"id" => id}) do
    tracked_earthquakes = TrackedEarthquakes.list_tracked_earthquakes_by_user(id)
    render(conn, "index.html", tracked_earthquakes: tracked_earthquakes)
  end

  def index(conn, _params) do
    tracked_earthquakes = TrackedEarthquakes.list_tracked_earthquakes()
    render(conn, "index.html", tracked_earthquakes: tracked_earthquakes)
  end

  def new(conn, _params) do
    changeset = TrackedEarthquakes.change_tracked_earthquake(%TrackedEarthquake{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tracked_earthquake" => tracked_earthquake_params}) do
    case TrackedEarthquakes.create_tracked_earthquake(tracked_earthquake_params) do
      {:ok, tracked_earthquake} ->
        user_id = get_session(conn, :user_id)
        conn
        |> put_flash(:info, "Tracked earthquake created successfully.")
        |> redirect(to: Routes.tracked_earthquake_path(conn, :index, %{"id": user_id}))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tracked_earthquake = TrackedEarthquakes.get_tracked_earthquake!(id)
    render(conn, "show.html", tracked_earthquake: tracked_earthquake)
  end

  def edit(conn, %{"id" => id}) do
    tracked_earthquake = TrackedEarthquakes.get_tracked_earthquake!(id)
    changeset = TrackedEarthquakes.change_tracked_earthquake(tracked_earthquake)
    render(conn, "edit.html", tracked_earthquake: tracked_earthquake, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tracked_earthquake" => tracked_earthquake_params}) do
    tracked_earthquake = TrackedEarthquakes.get_tracked_earthquake!(id)

    case TrackedEarthquakes.update_tracked_earthquake(tracked_earthquake, tracked_earthquake_params) do
      {:ok, tracked_earthquake} ->
        conn
        |> put_flash(:info, "Tracked earthquake updated successfully.")
        |> redirect(to: Routes.tracked_earthquake_path(conn, :show, tracked_earthquake))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tracked_earthquake: tracked_earthquake, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tracked_earthquake = TrackedEarthquakes.get_tracked_earthquake!(id)
    {:ok, _tracked_earthquake} = TrackedEarthquakes.delete_tracked_earthquake(tracked_earthquake)

    conn
    |> put_flash(:info, "Tracked earthquake deleted successfully.")
    |> redirect(to: Routes.tracked_earthquake_path(conn, :index))
  end
end
