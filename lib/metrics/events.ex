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
  def list_rsvps do
    Repo.all(RSVP)
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
