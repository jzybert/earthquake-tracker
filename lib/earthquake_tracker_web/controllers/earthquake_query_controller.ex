defmodule EarthquakeTrackerWeb.EarthquakeQueryController do
  use EarthquakeTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def query_earthquake(conn, %{"start_time" => start_time,
      "end_time" => end_time, "location" => location, "sq_min_lat" => sq_min_lat,
      "sq_max_lat" => sq_max_lat, "sq_min_lng" => sq_min_lng, "sq_max_lng" => sq_max_lng,
      "ci_lat" => ci_lat, "start_time" => ci_lng, "ci_max_rad" => ci_max_rad,}) do
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
    headers = []
    params = []

    parsed =
      case HTTPoison.get(url, headers, params: params) do
        {:ok, response} -> parse_eq_data(response)
        {:error, reason} -> %{}
      end

    IO.puts inspect(parsed)

    conn
    |> redirect(to: Routes.page_path(conn, :index))
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
end


