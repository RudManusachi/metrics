defmodule Metrics.Events.RSVP do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:response, :mtime, :guests, :id]}

  @primary_key {:id, :id, []}
  schema "rsvps" do
    field :guests, :integer
    field :member_id, :integer
    field :response, :string
    field :mtime, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(rsvp, attrs) do
    rsvp
    |> cast(attrs, [:member_id, :id, :guests, :response, :mtime])
    |> validate_required([:member_id, :id, :guests, :response, :mtime])
    |> unique_constraint(:id)
    |> unique_constraint(:mtime)
    |> unique_constraint(:primary_index, name: :_hyper_1_1_chunk_rsvps_mtime_id_index)
  end
end
