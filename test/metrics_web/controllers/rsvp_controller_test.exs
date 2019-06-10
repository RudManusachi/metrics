defmodule MetricsWeb.RSPVControllerTest do
  use MetricsWeb.ConnCase

  alias Metrics.Events

  test "index/2 responds with all RSPVs", %{conn: conn} do
    now = DateTime.utc_now()

    rsvps_changesets = [
      %{guests: 0, member_id: 42, response: "yes", id: 42, mtime: now},
      %{
        guests: 1,
        member_id: 43,
        response: "no",
        id: 43,
        mtime: DateTime.add(now, 300, :second)
      }
    ]

    [{:ok, rsvp1}, {:ok, rsvp2}] = Enum.map(rsvps_changesets, &Events.create_rsvp/1)

    response =
      conn
      |> get(Routes.rsvp_path(conn, :index))
      |> json_response(200)
      |> Enum.map(&Map.take(&1, ["response", "guests"]))

    expected = [
      %{"response" => rsvp1.response, "guests" => rsvp1.guests},
      %{"response" => rsvp2.response, "guests" => rsvp2.guests}
    ]

    assert response == expected
  end
end
