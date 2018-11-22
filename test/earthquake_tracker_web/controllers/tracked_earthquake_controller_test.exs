defmodule EarthquakeTrackerWeb.TrackedEarthquakeControllerTest do
  use EarthquakeTrackerWeb.ConnCase

  alias EarthquakeTracker.TrackedEarthquakes

  @create_attrs %{last_checked: ~N[2010-04-17 14:00:00], max_lat: "120.5", max_lng: "120.5", min_lat: "120.5", min_lng: "120.5"}
  @update_attrs %{last_checked: ~N[2011-05-18 15:01:01], max_lat: "456.7", max_lng: "456.7", min_lat: "456.7", min_lng: "456.7"}
  @invalid_attrs %{last_checked: nil, max_lat: nil, max_lng: nil, min_lat: nil, min_lng: nil}

  def fixture(:tracked_earthquake) do
    {:ok, tracked_earthquake} = TrackedEarthquakes.create_tracked_earthquake(@create_attrs)
    tracked_earthquake
  end

  describe "index" do
    test "lists all tracked_earthquakes", %{conn: conn} do
      conn = get(conn, Routes.tracked_earthquake_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tracked earthquakes"
    end
  end

  describe "new tracked_earthquake" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tracked_earthquake_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tracked earthquake"
    end
  end

  describe "create tracked_earthquake" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tracked_earthquake_path(conn, :create), tracked_earthquake: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tracked_earthquake_path(conn, :show, id)

      conn = get(conn, Routes.tracked_earthquake_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tracked earthquake"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tracked_earthquake_path(conn, :create), tracked_earthquake: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tracked earthquake"
    end
  end

  describe "edit tracked_earthquake" do
    setup [:create_tracked_earthquake]

    test "renders form for editing chosen tracked_earthquake", %{conn: conn, tracked_earthquake: tracked_earthquake} do
      conn = get(conn, Routes.tracked_earthquake_path(conn, :edit, tracked_earthquake))
      assert html_response(conn, 200) =~ "Edit Tracked earthquake"
    end
  end

  describe "update tracked_earthquake" do
    setup [:create_tracked_earthquake]

    test "redirects when data is valid", %{conn: conn, tracked_earthquake: tracked_earthquake} do
      conn = put(conn, Routes.tracked_earthquake_path(conn, :update, tracked_earthquake), tracked_earthquake: @update_attrs)
      assert redirected_to(conn) == Routes.tracked_earthquake_path(conn, :show, tracked_earthquake)

      conn = get(conn, Routes.tracked_earthquake_path(conn, :show, tracked_earthquake))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, tracked_earthquake: tracked_earthquake} do
      conn = put(conn, Routes.tracked_earthquake_path(conn, :update, tracked_earthquake), tracked_earthquake: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tracked earthquake"
    end
  end

  describe "delete tracked_earthquake" do
    setup [:create_tracked_earthquake]

    test "deletes chosen tracked_earthquake", %{conn: conn, tracked_earthquake: tracked_earthquake} do
      conn = delete(conn, Routes.tracked_earthquake_path(conn, :delete, tracked_earthquake))
      assert redirected_to(conn) == Routes.tracked_earthquake_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.tracked_earthquake_path(conn, :show, tracked_earthquake))
      end
    end
  end

  defp create_tracked_earthquake(_) do
    tracked_earthquake = fixture(:tracked_earthquake)
    {:ok, tracked_earthquake: tracked_earthquake}
  end
end
