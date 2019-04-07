defmodule CodeChallengeBackEnd.Location do
  @moduledoc """
  The Location context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS

  alias CodeChallengeBackEnd.Repo
  alias CodeChallengeBackEnd.Location.PDV

  @doc """
  Gets a single pdv.

  Raises `Ecto.NoResultsError` if the Pdv does not exist.

  ## Examples

      iex> get_pdv!(123)
      %PDV{}

      iex> get_pdv!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pdv!(id), do: Repo.get!(PDV, id)

  @doc """
  Gets a single pdv.

  ## Examples

      iex> get_pdv(123)
      %PDV{}

      iex> get_pdv!(456)
      nil

  """
  def get_pdv(id), do: Repo.get(PDV, id)

  @doc """
  Gets a single pdv that coverage the point and is the most close.

  ## Examples

      iex> search(point)
      %PDV{}

      iex> search(point)
      nil

  """
  def search(point) do
    query = from p in PDV,
            where: st_contains(p.coverageArea, ^point),
            limit: 1,
            order_by: st_distance(p.address, ^point)

    Repo.all(query)
  end

  @doc """
  Creates a pdv.

  ## Examples

      iex> create_pdv(%{field: value})
      {:ok, %PDV{}}

      iex> create_pdv(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pdv(attrs \\ %{}) do
    %PDV{}
    |> PDV.changeset(attrs)
    |> Repo.insert()
  end

  def change_pdv(%PDV{} = pdv) do
    PDV.changeset(pdv, %{})
  end
end
