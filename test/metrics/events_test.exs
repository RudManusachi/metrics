defmodule Metrics.EventsTest do
  use Metrics.DataCase

  alias Metrics.Events

  describe "rsvps" do
    alias Metrics.Events.RSVP

    @valid_attrs %{
      guests: 42,
      member_id: 42,
      response: "some response",
      id: 42,
      mtime: DateTime.utc_now()
    }
    @update_attrs %{
      guests: 43,
      member_id: 43,
      response: "some updated response",
      id: 43,
      mtime: DateTime.utc_now()
    }
    @invalid_attrs %{
      guests: nil,
      member_id: nil,
      response: nil,
      id: nil,
      mtime: nil
    }

    def rsvp_fixture(attrs \\ %{}) do
      {:ok, rsvp} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_rsvp()

      rsvp
    end

    test "list_rsvps/0 returns all rsvps" do
      rsvp = rsvp_fixture()
      assert Events.list_rsvps() == [rsvp]
    end

    test "get_rsvp!/1 returns the rsvp with given id" do
      rsvp = rsvp_fixture()
      assert Events.get_rsvp!(rsvp.id) == rsvp
    end

    test "create_rsvp/1 with valid data creates a rsvp" do
      assert {:ok, %RSVP{} = rsvp} = Events.create_rsvp(@valid_attrs)
      assert rsvp.guests == 42
      assert rsvp.member_id == 42
      assert rsvp.response == "some response"
      assert rsvp.id == 42
    end

    test "create_rsvp/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_rsvp(@invalid_attrs)
    end

    test "update_rsvp/2 with valid data updates the rsvp" do
      rsvp = rsvp_fixture()
      assert {:ok, %RSVP{} = rsvp} = Events.update_rsvp(rsvp, @update_attrs)
      assert rsvp.guests == 43
      assert rsvp.member_id == 43
      assert rsvp.response == "some updated response"
      assert rsvp.id == 43
    end

    test "update_rsvp/2 with invalid data returns error changeset" do
      rsvp = rsvp_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_rsvp(rsvp, @invalid_attrs)
      assert rsvp == Events.get_rsvp!(rsvp.id)
    end

    test "delete_rsvp/1 deletes the rsvp" do
      rsvp = rsvp_fixture()
      assert {:ok, %RSVP{}} = Events.delete_rsvp(rsvp)
      assert_raise Ecto.NoResultsError, fn -> Events.get_rsvp!(rsvp.id) end
    end

    test "change_rsvp/1 returns a rsvp changeset" do
      rsvp = rsvp_fixture()
      assert %Ecto.Changeset{} = Events.change_rsvp(rsvp)
    end
  end
end
