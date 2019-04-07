use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :code_challenge_back_end, CodeChallengeBackEndWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :code_challenge_back_end, CodeChallengeBackEnd.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: System.get_env("PGDATABASE") || "code_challenge_back_end_test",
  hostname: System.get_env("PGHOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  types: CodeChallengeBackEnd.PostgresTypes
