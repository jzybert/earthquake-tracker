defmodule EarthquakeTracker.Email do
  use Bamboo.Phoenix, view: EarthquakeTracker.EmailView

  import Bamboo.Email

  # For each type of email, define a new function to build the email

  def tracked_area_email(email_address) do
    new_email
    |> to(email_address)
    |> from("zybert.j@husky.neu.edu")
    |> subject("Earthquake Tracker - Tracked Areas")
    |> text_body("This is a test.")
  end
end