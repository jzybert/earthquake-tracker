defmodule EarthquakeTrackerWeb.NewsQueryController do
  use EarthquakeTrackerWeb, :controller

  def index(conn, _params) do
    articles = query_news(conn)
    render(conn, "index.html", articles: articles)
  end

  def query_news() do
    data = query_news_data()

    articles = Map.get(data, :article_data)
    num_of_articles = Map.get(data, :num_of_articles)

    Enum.filter(articles, fn article -> String.downcase(article.title) =~ "earthquake" ||
      String.downcase(article.description) =~ "earthquake" end)
  end

  def query_news(conn) do
    data = query_news_data()

    articles = Map.get(data, :article_data)
    num_of_articles = Map.get(data, :num_of_articles)

    if num_of_articles != -1 do
      Enum.filter(articles, fn article -> String.downcase(article.title) =~ "earthquake" ||
        String.downcase(article.description) =~ "earthquake" end)
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def query_news_data() do
    url = "https://newsapi.org/v2/everything?q=earthquake&from=" <> Date.to_string(Date.add(Date.utc_today(), -7)) <>
          "&sortBy=relevancy&pageSize=100&apiKey=" <> Application.get_env(:earthquake_tracker, News)[:news_api_key]

    headers = []
    params = []

    parsed =
      case HTTPoison.get(url, headers, params: params) do
        {:ok, response} -> parse_news_data(response)
        {:error, reason} -> IO.puts reason
      end

    if parsed do
      %{:articles => articles} = parsed
      num_of_articles = length(articles)
      article_data = Enum.map articles, fn article ->
        source = Map.get(Map.get(article, "source"), "name")
        {:ok, date, i} = DateTime.from_iso8601(Map.get(article, "publishedAt"))
        %{author: Map.get(article, "author"), title: Map.get(article, "title"),
          description: Map.get(article, "description"), url: Map.get(article, "url"),
          url_to_image: Map.get(article, "urlToImage"), published_at: "#{date.month}/#{date.day}/#{date.year}",
          source: source}
      end
      %{article_data: article_data, num_of_articles: num_of_articles}
    else
      %{article_data: [], num_of_articles: -1}
    end
  end

  defp parse_news_data(data) do
    decoded_data = Poison.decode(data.body)
    data_part = elem(decoded_data, 1)
    articles = Map.get(data_part, "articles")
    %{articles: articles}
  end
end
