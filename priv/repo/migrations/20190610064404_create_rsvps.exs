defmodule Metrics.Repo.Migrations.CreateRsvps do
  use Ecto.Migration

  def up do
    # enable timescaledb extension
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE")

    # timescaledb specifics cannot create unique index without the column "mtime"
    # that's why `primary_key: false`
    # [Custom primary key](https://phoenixframework.org/blog/custom-primary-key)
    create table(:rsvps, primary_key: false) do
      add :member_id, :integer, null: false
      add :id, :integer, null: false
      add :guests, :integer, null: false
      add :response, :string, null: false
      add :mtime, :utc_datetime, null: false

      timestamps()
    end

    create unique_index(:rsvps, [:mtime, :id])
    # convert rsvps to hypertable
    execute("SELECT create_hypertable('rsvps', 'mtime', 'id')")
  end

  def down do
    drop table(:rsvps)
    execute("DROP EXTENSION IF EXISTS timescaledb CASCADE")
  end
end
