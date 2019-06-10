defmodule Metrics.Meetup.Importer do
  @host "stream.meetup.com"
  @path "/2/rsvps"

  # in order to add to `application` supervision tree
  def start_link(_opts) do
    Task.start_link(fn -> run(fn _rsvp -> IO.inspect(:rsvp) end) end)
  end

  def run(fun, opts \\ []) do
    @host
    |> Socket.Web.connect!(path: @path, secure: true)
    |> loop_recv(fun, opts)
  end

  defp loop_recv(socket, fun, opts) do
    with {:text, rsvp_json} <- Socket.Web.recv!(socket),
         {:ok, rsvp} <- Jason.decode(rsvp_json) do
      fun.(rsvp)
    end

    do_loop_recv(socket, fun, opts)
  end

  defp do_loop_recv(_, _, :once), do: :ok
  defp do_loop_recv(socket, fun, opts), do: loop_recv(socket, fun, opts)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
