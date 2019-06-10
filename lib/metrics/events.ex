defmodule Metrics.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Metrics.Repo

  alias Metrics.Events.RSVP

  @doc """
  Returns the list of rsvps.

  ## Examples

      iex> list_rsvps()
      [%RSVP{}, ...]

  """
  def list_rsvps(params) do
    rsvps =
      params
      |> filter()
      |> Repo.all()

    {:ok, rsvps}
  end

  defp filter(query_params) do
    query_params
    |> Map.to_list()
    |> Enum.reduce(base_query(), &filter_by/2)
  end

  defp filter_by({"range", [from, to]}, q) do
    from(rsvp in q,
      where:
        ^DateTime.from_unix!(from, :millisecond) <= rsvp.mtime and
          rsvp.mtime <= ^DateTime.from_unix!(to, :millisecond)
    )
  end

  defp filter_by({"response", response}, q) do
    from(rsvp in q,
      where: rsvp.response == ^response
    )
  end

  defp filter_by({"time_bucket", bucket}, q) do
    from(rsvp in q,
      select: [fragment("time_bucket('1 minute', ?) as bucket", rsvp.mtime), count(rsvp.id)],
      group_by: fragment("bucket"),
      order_by: [desc: fragment("bucket")]
    )
  end

  defp filter_by(_, q), do: q

  defp base_query() do
    from(r in RSVP)
  end

  @doc """
  Gets a single rsvp.

  Raises `Ecto.NoResultsError` if the Rsvp does not exist.

  ## Examples

      iex> get_rsvp!(123)
      %RSVP{}

      iex> get_rsvp!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rsvp!(id), do: Repo.get!(RSVP, id)

  @doc """
  Creates a rsvp.

  ## Examples

      iex> create_rsvp(%{field: value})
      {:ok, %RSVP{}}

      iex> create_rsvp(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rsvp(attrs \\ %{}) do
    %RSVP{}
    |> RSVP.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rsvp.

  ## Examples

      iex> update_rsvp(rsvp, %{field: new_value})
      {:ok, %RSVP{}}

      iex> update_rsvp(rsvp, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rsvp(%RSVP{} = rsvp, attrs) do
    rsvp
    |> RSVP.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RSVP.

  ## Examples

      iex> delete_rsvp(rsvp)
      {:ok, %RSVP{}}

      iex> delete_rsvp(rsvp)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rsvp(%RSVP{} = rsvp) do
    Repo.delete(rsvp)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rsvp changes.

  ## Examples

      iex> change_rsvp(rsvp)
      %Ecto.Changeset{source: %RSVP{}}

  """
  def change_rsvp(%RSVP{} = rsvp) do
    RSVP.changeset(rsvp, %{})
  end
end
