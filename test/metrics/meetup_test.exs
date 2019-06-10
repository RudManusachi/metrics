defmodule Metrics.MeetupTest do
  use ExUnit.Case

  test "Meetup.Importer receives rsvps" do
    Metrics.Meetup.Importer.run(
      fn rsvp -> assert %{"response" => response, "member" => %{}} = rsvp end,
      :once
    )
  end
end
