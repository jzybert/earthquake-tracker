defmodule EarthquakeTrackerWeb.SessionController do
  use EarthquakeTrackerWeb, :controller

  alias EarthquakeTracker.Users

  def create(conn, %{"email" => email, "password" => password}) do
    user = Users.get_and_auth_user(email, password)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end