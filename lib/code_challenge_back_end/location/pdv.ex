defmodule CodeChallengeBackEnd.Location.PDV do
  use Ecto.Schema
  import Ecto.Changeset
  import Geo

  schema "pdvs" do
    field :address, Geo.PostGIS.Geometry
    field :coverageArea, Geo.PostGIS.Geometry
    field :document, :string
    field :ownerName, :string
    field :tradingName, :string

    timestamps()
  end

  @doc false
  def changeset(pdv, attrs) do
    pdv
    |> cast(attrs, [:tradingName, :ownerName])
    |> cast_coverage_area(attrs)
    |> cast_address(attrs)
    |> cast_document(attrs)
    |> validate_required([:tradingName, :ownerName, :document, :coverageArea, :address])
    |> unique_constraint(:document)
  end

  def cast_document(changeset, attrs) do
    if (Map.has_key?(attrs, "document") && !is_nil(Map.fetch!(attrs, "document"))) do
      if (Brcpfcnpj.cnpj_valid?(%Cnpj{number: Map.fetch!(attrs, "document")})) do
        put_change(changeset, :document, String.replace(Map.fetch!(attrs, "document"), ~r/[\p{P}\p{S}]/, ""))
      else
        add_error(changeset, :document, "Invalid document")
      end
    else
      changeset
    end
  end

  def cast_coverage_area(changeset, attrs) do
    if (Map.has_key?(attrs, "coverageArea") && !is_nil(Map.fetch!(attrs, "coverageArea"))) do
      put_change(changeset, :coverageArea, %Geo.MultiPolygon{coordinates: format_coverage_area(attrs["coverageArea"]["coordinates"]), srid: 4326})
    else
      changeset
    end
  end

  def cast_address(changeset, attrs) do
    if (Map.has_key?(attrs, "address") && !is_nil(Map.fetch!(attrs, "address"))) do
      put_change(changeset, :address, %Geo.Point{coordinates: format_address(attrs["address"]["coordinates"]), srid: 4326})
    else
      changeset
    end
  end

  def format_address(array) do
    if (is_list(array)) do
      {Enum.at(array, 0), Enum.at(array, 1)}
    else
      array
    end
  end

  def format_coverage_area(cube) do
    Enum.reduce(cube, [], fn row, accRow ->
      row = Enum.reduce(row, [], fn coordinates, accLine ->
         line = Enum.reduce(coordinates, [], fn coordinate, accCoordinates ->
          case coordinate do
            c when is_list(c) -> accCoordinates ++ [List.to_tuple(c)]
            c when is_tuple(c) -> accCoordinates ++ [Tuple.to_list(c)]
            c -> accCoordinates ++ [c]
          end
        end)
        accLine ++ [line]
      end)
      accRow ++ [row]
    end)
  end
end
