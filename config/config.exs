# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :code_challenge_back_end,
  ecto_repos: [CodeChallengeBackEnd.Repo]

config :code_challenge_back_end, CodeChallengeBackEnd.Repo,
  types: CodeChallengeBackEnd.PostgresTypes

# Configures the endpoint
config :code_challenge_back_end, CodeChallengeBackEndWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XwtPEzlW9BIkvxHyttazHlus8vSAFEn8Q7mY+aDpWhArqDc1BgUD3Xty6t4IJGAh",
  render_errors: [view: CodeChallengeBackEndWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CodeChallengeBackEnd.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
