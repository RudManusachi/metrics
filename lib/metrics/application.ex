defmodule Metrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Metrics.Repo,
      # Start the endpoint when the application starts
      MetricsWeb.Endpoint
      # Starts a worker by calling: Metrics.Worker.start_link(arg)
      # {Metrics.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Metrics.Supervisor]
    Supervisor.start_link(children ++ custom_worker(), opts)
  end

  defp custom_worker() do
    if Application.get_env(:metrics, :enable_rsvp_importer, true),
      do: [Metrics.Meetup.Importer],
      else: []
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MetricsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
