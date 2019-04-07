defmodule CodeChallengeBackEnd.Repo.Migrations.CreatePdvs do
  use Ecto.Migration

  def change do
    create table(:pdvs) do
      add :tradingName, :string
      add :ownerName, :string
      add :document, :string
      add :coverageArea, :"geometry(MultiPolygon, 4326)"
      add :address, :"geometry(Point, 4326)"

      timestamps()
    end

    create unique_index(:pdvs, [:document])
  end
end
