defmodule MetricsWeb.RSVPController do
  use MetricsWeb, :controller

  alias Metrics.Events

  def index(conn, _args) do
    json(conn, Events.list_rsvps())
  end
end
