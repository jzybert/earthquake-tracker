defmodule EarthquakeTrackerWeb.Router do
  use EarthquakeTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EarthquakeTrackerWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EarthquakeTrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tracked_earthquakes", TrackedEarthquakeController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/query_earthquake", EarthquakeQueryController, only: [:show], singleton: true
    get "/query_earthquake", EarthquakeQueryController, :query_earthquake
    post "/query_earthquake", EarthquakeQueryController, :query_earthquake
    get "/query_earthquake/send_email", EarthquakeQueryController, :send_email
    resources "/news", NewsQueryController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", EarthquakeTrackerWeb do
  #   pipe_through :api
  # end
end
