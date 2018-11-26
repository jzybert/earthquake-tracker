defmodule EarthquakeTrackerWeb.NewsChannel do
  use EarthquakeTrackerWeb, :channel

  alias EarthquakeTrackerWeb.NewsQueryController

  def join("news:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (news:lobby).
  def handle_in("shout", payload, socket) do
    # query the news
    articles = NewsQueryController.channel_query_news()
    articles = Enum.map(articles, fn article -> Poison.encode!(article) end)
    # shout the info
    broadcast socket, "shout", %{articles => articles}
    {:noreply, socket}
  end

  def handle_in("more", payload, socket) do
    # query the news
    articles = NewsQueryController.channel_query_news(Map.get(payload, "page"))
    articles = Enum.map(articles, fn article -> Poison.encode!(article) end)
    # shout the info
    broadcast socket, "more", %{articles => articles}
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
