defmodule EarthquakeTracker.EarthquakeQuery.EarthquakeQuery do
  defstruct [:start_time, :end_time, :location, :sq_min_lat, :sq_max_lat,
             :sq_min_lng, :sq_max_lng, :ci_lat, :ci_lng, :ci_max_rad]
end
