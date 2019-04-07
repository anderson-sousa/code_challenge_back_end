defmodule CodeChallengeBackEndWeb.Router do
  use CodeChallengeBackEndWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CodeChallengeBackEndWeb do
    pipe_through :api

    get "/pdvs/search", PDVController, :search
    resources "/pdvs", PDVController, only: [:create, :show]
  end
end
