defmodule EarthquakeTracker.TrackedEarthquakesTest do
  use EarthquakeTracker.DataCase

  alias EarthquakeTracker.TrackedEarthquakes

  describe "tracked_earthquakes" do
    alias EarthquakeTracker.TrackedEarthquakes.TrackedEarthquake

    @valid_attrs %{last_checked: ~N[2010-04-17 14:00:00], max_lat: "120.5", max_lng: "120.5", min_lat: "120.5", min_lng: "120.5"}
    @update_attrs %{last_checked: ~N[2011-05-18 15:01:01], max_lat: "456.7", max_lng: "456.7", min_lat: "456.7", min_lng: "456.7"}
    @invalid_attrs %{last_checked: nil, max_lat: nil, max_lng: nil, min_lat: nil, min_lng: nil}

    def tracked_earthquake_fixture(attrs \\ %{}) do
      {:ok, tracked_earthquake} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TrackedEarthquakes.create_tracked_earthquake()

      tracked_earthquake
    end

    test "list_tracked_earthquakes/0 returns all tracked_earthquakes" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert TrackedEarthquakes.list_tracked_earthquakes() == [tracked_earthquake]
    end

    test "get_tracked_earthquake!/1 returns the tracked_earthquake with given id" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert TrackedEarthquakes.get_tracked_earthquake!(tracked_earthquake.id) == tracked_earthquake
    end

    test "create_tracked_earthquake/1 with valid data creates a tracked_earthquake" do
      assert {:ok, %TrackedEarthquake{} = tracked_earthquake} = TrackedEarthquakes.create_tracked_earthquake(@valid_attrs)
      assert tracked_earthquake.last_checked == ~N[2010-04-17 14:00:00]
      assert tracked_earthquake.max_lat == Decimal.new("120.5")
      assert tracked_earthquake.max_lng == Decimal.new("120.5")
      assert tracked_earthquake.min_lat == Decimal.new("120.5")
      assert tracked_earthquake.min_lng == Decimal.new("120.5")
    end

    test "create_tracked_earthquake/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackedEarthquakes.create_tracked_earthquake(@invalid_attrs)
    end

    test "update_tracked_earthquake/2 with valid data updates the tracked_earthquake" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert {:ok, %TrackedEarthquake{} = tracked_earthquake} = TrackedEarthquakes.update_tracked_earthquake(tracked_earthquake, @update_attrs)

      
      assert tracked_earthquake.last_checked == ~N[2011-05-18 15:01:01]
      assert tracked_earthquake.max_lat == Decimal.new("456.7")
      assert tracked_earthquake.max_lng == Decimal.new("456.7")
      assert tracked_earthquake.min_lat == Decimal.new("456.7")
      assert tracked_earthquake.min_lng == Decimal.new("456.7")
    end

    test "update_tracked_earthquake/2 with invalid data returns error changeset" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert {:error, %Ecto.Changeset{}} = TrackedEarthquakes.update_tracked_earthquake(tracked_earthquake, @invalid_attrs)
      assert tracked_earthquake == TrackedEarthquakes.get_tracked_earthquake!(tracked_earthquake.id)
    end

    test "delete_tracked_earthquake/1 deletes the tracked_earthquake" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert {:ok, %TrackedEarthquake{}} = TrackedEarthquakes.delete_tracked_earthquake(tracked_earthquake)
      assert_raise Ecto.NoResultsError, fn -> TrackedEarthquakes.get_tracked_earthquake!(tracked_earthquake.id) end
    end

    test "change_tracked_earthquake/1 returns a tracked_earthquake changeset" do
      tracked_earthquake = tracked_earthquake_fixture()
      assert %Ecto.Changeset{} = TrackedEarthquakes.change_tracked_earthquake(tracked_earthquake)
    end
  end
end
