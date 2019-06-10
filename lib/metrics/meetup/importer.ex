defmodule Metrics.Meetup.Importer do
  @host "stream.meetup.com"
  @path "/2/rsvps"

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

  @doc false
  defp do_loop_recv(_, _, :once), do: :ok
  defp do_loop_recv(socket, fun, opts), do: loop_recv(socket, fun, opts)
end
