defmodule CodeChallengeBackEnd.LocationTest do
  use CodeChallengeBackEnd.DataCase

  alias CodeChallengeBackEnd.Location

  describe "pdvs" do
    alias CodeChallengeBackEnd.Location.PDV

    @valid_attrs %{
      "address" => %{
        "coordinates" => [30, -90]
      },
      "coverageArea" => %{
        "coordinates" => [
          [
            [
              [30, 20], [45, 40], [10, 40], [30, 20]
            ]
          ],
          [
            [
              [15, 5], [40, 10], [10, 20], [5, 10], [15, 5]
            ]
          ]
        ]
      },
      "document" => "69.103.604/0001-60",
      "ownerName" => "some ownerName",
      "tradingName" => "some tradingName"
    }
    @invalid_attrs %{
      address: nil,
      coverageArea: nil,
      document: nil,
      ownerName: nil,
      tradingName: nil
    }

    def pdv_fixture(attrs \\ %{}) do
      {:ok, pdv} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Location.create_pdv()

      pdv
    end

    test "get_pdv!/1 returns the pdv with given id" do
      pdv = pdv_fixture()
      assert Location.get_pdv!(pdv.id) == pdv
    end

    test "create_pdv/1 with valid data creates a pdv" do
      assert {:ok, %PDV{} = pdv} = Location.create_pdv(@valid_attrs)
      assert pdv.address == %Geo.Point{coordinates: {30, -90}, properties: %{}, srid: 4326}
      assert pdv.coverageArea == %Geo.MultiPolygon{coordinates: [[[{30, 20}, {45, 40}, {10, 40}, {30, 20}]], [[{15, 5}, {40, 10}, {10, 20}, {5, 10}, {15, 5}]]], properties: %{}, srid: 4326}
      assert pdv.document == String.replace(@valid_attrs["document"], ~r/[\p{P}\p{S}]/, "")
      assert pdv.ownerName == @valid_attrs["ownerName"]
      assert pdv.tradingName == @valid_attrs["tradingName"]
    end

    test "create_pdv/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_pdv(@invalid_attrs)
    end

    test "change_pdv/1 returns a pdv changeset" do
      pdv = pdv_fixture()
      assert %Ecto.Changeset{} = Location.change_pdv(pdv)
    end
  end
end
