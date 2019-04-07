defmodule CodeChallengeBackEnd.Repo do
  use Ecto.Repo,
    otp_app: :code_challenge_back_end,
    adapter: Ecto.Adapters.Postgres
end
