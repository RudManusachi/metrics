defmodule MetricsWeb.RSVPController do
  use MetricsWeb, :controller

  alias Metrics.Events

  def index(conn, params) do
    {:ok, rsvps} = Events.list_rsvps(params)
    json(conn, rsvps)
  end
end
