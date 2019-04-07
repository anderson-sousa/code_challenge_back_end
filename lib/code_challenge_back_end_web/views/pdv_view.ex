defmodule CodeChallengeBackEndWeb.PDVView do
  use CodeChallengeBackEndWeb, :view
  alias CodeChallengeBackEndWeb.PDVView
  alias CodeChallengeBackEnd.Location.PDV

  def render("index.json", %{pdvs: pdvs}) do
    %{
      data: render_many(pdvs, PDVView, "pdv.json")
    }
  end

  def render("show.json", %{pdv: pdv}) do
    %{
      data: render_one(pdv, PDVView, "pdv.json")
    }
  end

  def render("pdv.json", %{pdv: pdv}) do
    %{
      id: pdv.id,
      address: %{
        type: "Point",
        coordinates: Tuple.to_list(pdv.address.coordinates)
      },
      coverageArea: %{
        type: "MultiPolygon",
        coordinates: PDV.format_coverage_area(pdv.coverageArea.coordinates)
      },
      document: pdv.document,
      ownerName: pdv.ownerName,
      tradingName: pdv.tradingName
    }
  end

  def render("search_empty.json", %{}) do
    %{
      errors: %{
        detail: "Outside the coverage area"
      }
    }
  end
end
