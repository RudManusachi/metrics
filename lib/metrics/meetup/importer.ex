defmodule Metrics.Meetup.Importer do
  alias Metrics.Events

  @host "stream.meetup.com"
  @path "/2/rsvps"

  # in order to add to `application` supervision tree
  def start_link(_opts) do
    Task.start_link(__MODULE__, :run, [&save_rsvp/1])
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

  defp save_rsvp(
         %{"rsvp_id" => id, "mtime" => mtimestamp, "member" => %{"member_id" => member_id}} = rsvp
       ) do
    rsvp
    |> Map.merge(%{
      "member_id" => member_id,
      "id" => id,
      "mtime" => DateTime.from_unix!(mtimestamp, :millisecond)
    })
    |> Events.create_rsvp()
  end

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
