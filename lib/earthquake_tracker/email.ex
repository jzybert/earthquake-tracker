defmodule EarthquakeTracker.Email do
  use Bamboo.Phoenix, view: EarthquakeTracker.EmailView

  import Bamboo.Email

  # For each type of email, define a new function to build the email

  def tracked_area_email(email_address, query) do
    %{:eq_data => eq_data, :name => name, :num_eq => num_eq} = query

    new_email
    |> to(email_address)
    |> from("zybert.j@husky.neu.edu")
    |> subject("Earthquake Tracker - Tracked Areas")
    |> put_html_layout({EarthquakeTrackerWeb.LayoutView, "email.html"})
    |> render("email.html", eq_data: eq_data, name: name, num_eq: num_eq)
  end
end