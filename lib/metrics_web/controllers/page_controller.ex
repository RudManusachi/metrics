defmodule MetricsWeb.PageController do
  use MetricsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
