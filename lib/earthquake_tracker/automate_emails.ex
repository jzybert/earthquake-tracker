# Automation code derived from https://stackoverflow.com/questions/32085258/how-can-i-schedule-code-to-run-every-few-hours-in-elixir-or-phoenix-framework
defmodule EarthquakeTracker.AutomateEmails do
  use GenServer

  alias EarthquakeTracker.Email
  alias EarthquakeTracker.Mailer
  alias EarthquakeTracker.Users
  alias EarthquakeTracker.TrackedEarthquakes
  alias EarthquakeTrackerWeb.EarthquakeQueryController

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Send emails for each user
    users = Users.list_users()
    Enum.each users, fn user ->
      %{:email => email, :email_notifications => opted_in, :id => id} = user
      if opted_in do
        try do
          tracked = TrackedEarthquakes.list_tracked_earthquakes_by_user(id)
          queries = query_for_each_tracked(tracked)
          # Send email for each tracked query
          Enum.each queries, fn query ->
            Email.tracked_area_email(email, query) |> Mailer.deliver_later
          end
        rescue
          Bamboo.SMTPAdapter.SMTPError -> "Could not send email."
        end
      end
    end

    # Reschedule work
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000) # Every 1 day
  end

  defp query_for_each_tracked(tracked) do
    queried_data = Enum.map tracked, fn area ->
      %{:max_lat => sq_max_lat, :max_lng => sq_max_lng, :min_lat => sq_min_lat, :min_lng => sq_min_lng,
        :max_mag => max_mag, :min_mag => min_mag, :name => name} = area
      location = "square"
      start_time = Date.to_string(Date.add(Date.utc_today(), -1))
      end_time = Date.to_string(Date.utc_today())
      min_mag = if min_mag, do: Decimal.to_string(min_mag), else: ""
      max_mag = if max_mag, do: Decimal.to_string(max_mag), else: ""
      data = EarthquakeQueryController.query_eq_data(start_time, end_time, location, Decimal.to_string(sq_min_lat),
        Decimal.to_string(sq_max_lat), Decimal.to_string(sq_min_lng),
        Decimal.to_string(sq_max_lng), "", "", "", min_mag, max_mag)
      %{earthquake_data: earthquake_data, num_of_earthquakes: num_of_earthquakes} = data
      %{name: name, eq_data: earthquake_data, num_eq: num_of_earthquakes}
    end
    queried_data
  end
end