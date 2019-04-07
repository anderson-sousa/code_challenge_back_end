defmodule CodeChallengeBackEndWeb.PDVController do
  use CodeChallengeBackEndWeb, :controller

  alias CodeChallengeBackEnd.Location
  alias CodeChallengeBackEnd.Location.PDV

  action_fallback CodeChallengeBackEndWeb.FallbackController

  def create(conn, %{"pdv" => pdv_params}) do
    case Location.create_pdv(pdv_params) do
      {:ok, %PDV{} = pdv} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.pdv_path(conn, :show, pdv))
          |> render("show.json", pdv: pdv)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> put_view(CodeChallengeBackEndWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Location.get_pdv(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(CodeChallengeBackEndWeb.ErrorView)
        |> render("404.json")
      pdv ->
        render(conn, "show.json", pdv: pdv)
    end
  end

  def search(conn, %{"lat" => lat, "lng" => lng}) do
    point = %Geo.Point{ coordinates: {lng, lat}, srid: 4326}
    pdvs = Location.search(point)
    if (Enum.empty?(pdvs)) do
      conn
        |> put_status(:not_found)
        |> render("search_empty.json", %{})
    else
      render(conn, "show.json", pdv: Enum.at(pdvs, 0))
    end
  end
end
