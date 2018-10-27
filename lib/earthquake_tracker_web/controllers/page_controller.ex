defmodule EarthquakeTrackerWeb.PageController do
  use EarthquakeTrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
