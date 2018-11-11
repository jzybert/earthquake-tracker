defmodule EarthquakeTrackerWeb.EarthquakeQueryController do
  use EarthquakeTrackerWeb, :controller

  def query_earthquake(conn, _params) do
    url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2014-01-01&endtime=2014-01-02&minmagnitude=5"
    headers = []
    params = []

    case HTTPoison.get(url, headers, params: params) do
      {:ok, response} -> parse_eq_data(response)
      {:error, reason} -> IO.puts inspect(reason)
    end

    conn
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp parse_eq_data(data) do
    decoded_data = Poison.decode(data.body)
    data_part = elem(decoded_data, 1)
    metadata = Map.get(data_part, "metadata")
    features = Map.get(data_part, "features")
    IO.puts inspect(metadata)
    IO.puts inspect(features)
  end
end


