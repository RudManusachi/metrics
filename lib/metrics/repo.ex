defmodule Metrics.Repo do
  use Ecto.Repo,
    otp_app: :metrics,
    adapter: Ecto.Adapters.Postgres
end
