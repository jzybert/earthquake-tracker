defmodule EarthquakeTrackerWeb.EarthquakeQueryController do
  use EarthquakeTrackerWeb, :controller

  alias EarthquakeTracker.Email
  alias EarthquakeTracker.Mailer
  alias EarthquakeTracker.TrackedEarthquakes

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"eq_data" => eq_data, "num_eq" => num_eq, "start_time" => start_time, "end_time" => end_time}) do
    render(conn, "show.html", eq_data: eq_data, num_eq: num_eq, start_time: start_time, end_time: end_time)
  end

  def send_email(conn, %{"email_address" => email_address, "opted_in" => opted_in, "id" => id}) do
    if opted_in == "true" do
      try do
        tracked = TrackedEarthquakes.list_tracked_earthquakes_by_user(id)
        queries = query_for_each_tracked(tracked)
        Email.tracked_area_email(email_address, hd queries) |> Mailer.deliver_now
        conn
        |> redirect(to: Routes.page_path(conn, :index))
      rescue
        e in Bamboo.SMTPAdapter.SMTPError ->
          conn
          |> put_flash(:error, "Failed to send email via AWS.")
          |> redirect(to: Routes.page_path(conn, :index))
      end
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def query_earthquake(conn, %{"start_time" => start_time,
      "end_time" => end_time, "location" => location, "sq_min_lat" => sq_min_lat,
      "sq_max_lat" => sq_max_lat, "sq_min_lng" => sq_min_lng, "sq_max_lng" => sq_max_lng,
      "ci_lat" => ci_lat, "ci_lng" => ci_lng, "ci_max_rad" => ci_max_rad, "min_mag" => min_mag,
      "max_mag" => max_mag}) do

    data = query_eq_data(start_time,  end_time, location, sq_min_lat, sq_max_lat, sq_min_lng,
      sq_max_lng, ci_lat, ci_lng, ci_max_rad, min_mag, max_mag)

    earthquake_data = Map.get(data, :earthquake_data)
    num_of_earthquakes = Map.get(data, :num_of_earthquakes)

    if num_of_earthquakes != -1 do
      conn
      |> render("show.html", eq_data: earthquake_data, num_eq: num_of_earthquakes,
           start_time: start_time, end_time: end_time)
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp query_eq_data(start_time, end_time, location, sq_min_lat, sq_max_lat, sq_min_lng, sq_max_lng,
         ci_lat, ci_lng, ci_max_rad, min_mag, max_mag) do
    url = base_string() <> add_time(start_time, end_time)
    url =
      if location == "square" do
        url <> add_square(sq_min_lat, sq_max_lat, sq_min_lng, sq_max_lng)
      else
        if location == "circle" do
          url <> add_circle(ci_lat, ci_lng, ci_max_rad)
        else
          url
        end
      end
    url =
      if min_mag != "" || max_mag != "" do
        url <> add_magnitude(min_mag, max_mag)
      else
        url
      end

    headers = []
    params = []

    parsed =
      case HTTPoison.get(url, headers, params: params) do
        {:ok, response} -> parse_eq_data(response)
        {:error, reason} -> IO.puts reason
      end

    if parsed do
      %{:metadata => metadata, :features => features} = parsed
      num_of_earthquakes = Map.get(metadata, "count")
      earthquake_data = Enum.map features, fn eq ->
        [long | [lat | [depth]]] = Map.get(Map.get(eq, "geometry"), "coordinates")
        props = Map.get(eq, "properties")
        %{mag: Map.get(props, "mag"), place: Map.get(props, "place"), time: Map.get(props, "time"),
          mmi: Map.get(props, "mmi"), longitude: long, latitude: lat, depth: depth}
      end
      %{earthquake_data: earthquake_data, num_of_earthquakes: num_of_earthquakes}
    else
      %{earthquake_data: [], num_of_earthquakes: -1}
    end
  end

  defp parse_eq_data(data) do
    decoded_data = Poison.decode(data.body)
    data_part = elem(decoded_data, 1)
    metadata = Map.get(data_part, "metadata")
    features = Map.get(data_part, "features")
    %{"metadata": metadata, "features": features}
  end

  defp base_string(), do: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson"

  defp add_time(start_time, end_time) do
    "&starttime=" <> start_time <> "&endtime=" <> end_time
  end

  defp add_square(min_lat, max_lat, min_lng, max_lng) do
    "&minlatitude=" <> min_lat <> "&maxlatitude=" <> max_lat
    <> "&minlongitude=" <> min_lng <> "&maxlongitude=" <> max_lng
  end

  defp add_circle(lat, lng, rad) do
    "&latitude=" <> lat <> "&longitude=" <> lng <> "&maxradius=" <> rad
  end

  defp add_magnitude(min_mag, max_mag) do
    "&minmagnitude=" <> min_mag <> "&maxmagnitude=" <> max_mag
  end

  defp query_for_each_tracked(tracked) do
    queried_data = Enum.map(tracked, fn area ->
      %{:max_lat => sq_max_lat, :max_lng => sq_max_lng, :min_lat => sq_min_lat, :min_lng => sq_min_lng,
        :max_mag => max_mag, :min_mag => min_mag, :name => name, :last_checked => last_checked} = area
      location = "square"
      start_time = Date.to_string(Date.add(Date.utc_today(), -1))
      end_time = Date.to_string(Date.utc_today())
      min_mag = if min_mag, do: Decimal.to_string(min_mag), else: ""
      max_mag = if max_mag, do: Decimal.to_string(max_mag), else: ""
      data = query_eq_data(start_time, end_time, location, Decimal.to_string(sq_min_lat),
        Decimal.to_string(sq_max_lat), Decimal.to_string(sq_min_lng),
        Decimal.to_string(sq_max_lng), "", "", "", min_mag, max_mag)
      %{earthquake_data: earthquake_data, num_of_earthquakes: num_of_earthquakes} = data
      %{name: name, eq_data: earthquake_data, num_eq: num_of_earthquakes}
    end)
    queried_data
  end
end
