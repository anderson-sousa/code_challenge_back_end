Postgrex.Types.define(
  CodeChallengeBackEnd.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
