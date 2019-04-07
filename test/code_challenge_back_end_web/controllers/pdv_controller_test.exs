defmodule CodeChallengeBackEndWeb.PDVControllerTest do
  use CodeChallengeBackEndWeb.ConnCase

  alias CodeChallengeBackEnd.Location
  alias CodeChallengeBackEnd.Location.PDV

  @create_attrs %{
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

  def fixture(:pdv) do
    {:ok, pdv} = Location.create_pdv(@create_attrs)
    pdv
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create pdv" do
    test "renders pdv when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pdv_path(conn, :create), pdv: @create_attrs)
      data = json_response(conn, 201)["data"]

      assert is_integer(data["id"])
      assert data["address"] == %{
        "type" => "Point",
        "coordinates" => @create_attrs["address"]["coordinates"],
      }
      assert data["coverageArea"] == %{
        "type" => "MultiPolygon",
        "coordinates" => @create_attrs["coverageArea"]["coordinates"]
      }
      assert data["document"] == String.replace(@create_attrs["document"], ~r/[\p{P}\p{S}]/, "")
      assert data["ownerName"] == @create_attrs["ownerName"]
      assert data["tradingName"] == @create_attrs["tradingName"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pdv_path(conn, :create), pdv: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show pdv" do
    test "renders pdv when id is valid", %{conn: conn} do
      pdv = fixture(:pdv)
      response = get(conn, Routes.pdv_path(conn, :show, pdv.id))
      data = json_response(response, 200)["data"]

      assert is_integer(data["id"])
      assert data["address"] == %{
        "type" => "Point",
        "coordinates" => @create_attrs["address"]["coordinates"],
      }
      assert data["coverageArea"] == %{
        "type" => "MultiPolygon",
        "coordinates" => @create_attrs["coverageArea"]["coordinates"]
      }
      assert data["document"] == String.replace(@create_attrs["document"], ~r/[\p{P}\p{S}]/, "")
      assert data["ownerName"] == @create_attrs["ownerName"]
      assert data["tradingName"] == @create_attrs["tradingName"]
    end

    test "renders not found when id don't exists", %{conn: conn} do
      conn = get(conn, Routes.pdv_path(conn, :show, 999_999_999))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "search pdv by user location" do
    test "render pdv most close of the given point", %{conn: conn} do
      {:ok, pdv} = CodeChallengeBackEnd.Repo.insert(PDV.changeset(%PDV{},%{
        "id" => "28",
        "tradingName" => "Adega Ambev",
        "ownerName" => "Eduardo Pedroso",
        "document" => "21.658.641/0001-08",
        "coverageArea" => %{
           "type" => "MultiPolygon",
           "coordinates" => [
              [
                 [
                    [
                       -46.61158,
                       -23.5912
                    ],
                    [
                       -46.58534,
                       -23.5879
                    ],
                    [
                       -46.5661,
                       -23.58523
                    ],
                    [
                       -46.54688,
                       -23.58775
                    ],
                    [
                       -46.5352,
                       -23.58868
                    ],
                    [
                       -46.5213,
                       -23.59828
                    ],
                    [
                       -46.51272,
                       -23.60804
                    ],
                    [
                       -46.50499,
                       -23.63304
                    ],
                    [
                       -46.50939,
                       -23.64645
                    ],
                    [
                       -46.51099,
                       -23.65512
                    ],
                    [
                       -46.52135,
                       -23.65954
                    ],
                    [
                       -46.54267,
                       -23.66591
                    ],
                    [
                       -46.55936,
                       -23.66762
                    ],
                    [
                       -46.57029,
                       -23.66646
                    ],
                    [
                       -46.58004,
                       -23.66971
                    ],
                    [
                       -46.597,
                       -23.66402
                    ],
                    [
                       -46.61923,
                       -23.62762
                    ],
                    [
                       -46.62625,
                       -23.62123
                    ],
                    [
                       -46.62753,
                       -23.61056
                    ],
                    [
                       -46.62253,
                       -23.59887
                    ],
                    [
                       -46.61158,
                       -23.5912
                    ]
                 ]
              ]
           ]
        },
        "address" => %{
           "type" => "Point",
           "coordinates" => [
              -46.545303,
              -23.629513
           ]
        }
      }))
      CodeChallengeBackEnd.Repo.insert(PDV.changeset(%PDV{},%{
        "id" => "33",
        "tradingName" => "Adega do Joao",
        "ownerName" => "Pedro Silva",
        "document" => "23.459.215/0001-70",
        "coverageArea" => %{
           "type" => "MultiPolygon",
           "coordinates" => [
              [
                 [
                    [
                       -46.47199,
                       -23.66131
                    ],
                    [
                       -46.4826,
                       -23.65707
                    ],
                    [
                       -46.48557,
                       -23.6569
                    ],
                    [
                       -46.4907,
                       -23.65845
                    ],
                    [
                       -46.49819,
                       -23.65724
                    ],
                    [
                       -46.51155,
                       -23.65218
                    ],
                    [
                       -46.51366,
                       -23.65199
                    ],
                    [
                       -46.51878,
                       -23.65252
                    ],
                    [
                       -46.5208,
                       -23.65199
                    ],
                    [
                       -46.52282,
                       -23.65045
                    ],
                    [
                       -46.52669,
                       -23.64806
                    ],
                    [
                       -46.52884,
                       -23.64549
                    ],
                    [
                       -46.53132,
                       -23.64484
                    ],
                    [
                       -46.53312,
                       -23.6423
                    ],
                    [
                       -46.53447,
                       -23.6387
                    ],
                    [
                       -46.52514,
                       -23.62463
                    ],
                    [
                       -46.52113,
                       -23.61543
                    ],
                    [
                       -46.5098,
                       -23.60442
                    ],
                    [
                       -46.49057,
                       -23.58145
                    ],
                    [
                       -46.46469,
                       -23.59419
                    ],
                    [
                       -46.44948,
                       -23.59286
                    ],
                    [
                       -46.4432,
                       -23.59034
                    ],
                    [
                       -46.43582,
                       -23.58912
                    ],
                    [
                       -46.43311,
                       -23.59028
                    ],
                    [
                       -46.43105,
                       -23.59514
                    ],
                    [
                       -46.43508,
                       -23.60829
                    ],
                    [
                       -46.44083,
                       -23.60995
                    ],
                    [
                       -46.43991,
                       -23.61276
                    ],
                    [
                       -46.44016,
                       -23.61494
                    ],
                    [
                       -46.44186,
                       -23.61656
                    ],
                    [
                       -46.43946,
                       -23.61956
                    ],
                    [
                       -46.43922,
                       -23.62917
                    ],
                    [
                       -46.44087,
                       -23.63195
                    ],
                    [
                       -46.4414,
                       -23.63455
                    ],
                    [
                       -46.44298,
                       -23.63537
                    ],
                    [
                       -46.44425,
                       -23.63565
                    ],
                    [
                       -46.44465,
                       -23.63601
                    ],
                    [
                       -46.44504,
                       -23.63682
                    ],
                    [
                       -46.44643,
                       -23.63685
                    ],
                    [
                       -46.44809,
                       -23.63763
                    ],
                    [
                       -46.44909,
                       -23.63718
                    ],
                    [
                       -46.44977,
                       -23.63735
                    ],
                    [
                       -46.45005,
                       -23.63836
                    ],
                    [
                       -46.4502,
                       -23.63982
                    ],
                    [
                       -46.45087,
                       -23.64002
                    ],
                    [
                       -46.45122,
                       -23.64056
                    ],
                    [
                       -46.4524,
                       -23.64141
                    ],
                    [
                       -46.45498,
                       -23.64182
                    ],
                    [
                       -46.45359,
                       -23.64355
                    ],
                    [
                       -46.45761,
                       -23.64582
                    ],
                    [
                       -46.46162,
                       -23.65081
                    ],
                    [
                       -46.46684,
                       -23.65219
                    ],
                    [
                       -46.47128,
                       -23.65665
                    ],
                    [
                       -46.47199,
                       -23.66131
                    ]
                 ]
              ]
           ]
        },
        "address" => %{
           "type" => "Point",
           "coordinates" => [
              -46.471943,
              -23.618591
           ]
        }
      }))
      CodeChallengeBackEnd.Repo.insert(PDV.changeset(%PDV{},%{
        "id" => "15",
        "tradingName" => "Emporio da Cerveja",
        "ownerName" => "Joao Maradona",
        "document" => "11.863.940/0001-20",
        "coverageArea" => %{
           "type" => "MultiPolygon",
           "coordinates" => [
              [
                 [
                    [
                       -46.5292,
                       -23.58735
                    ],
                    [
                       -46.53503,
                       -23.5975
                    ],
                    [
                       -46.5219,
                       -23.61527
                    ],
                    [
                       -46.5139,
                       -23.62034
                    ],
                    [
                       -46.51087,
                       -23.62479
                    ],
                    [
                       -46.50396,
                       -23.62738
                    ],
                    [
                       -46.50336,
                       -23.63424
                    ],
                    [
                       -46.49512,
                       -23.64432
                    ],
                    [
                       -46.4886,
                       -23.647
                    ],
                    [
                       -46.4686,
                       -23.65435
                    ],
                    [
                       -46.46036,
                       -23.65006
                    ],
                    [
                       -46.4559,
                       -23.64043
                    ],
                    [
                       -46.45143,
                       -23.63611
                    ],
                    [
                       -46.4504,
                       -23.62278
                    ],
                    [
                       -46.44233,
                       -23.61627
                    ],
                    [
                       -46.43942,
                       -23.61255
                    ],
                    [
                       -46.44508,
                       -23.59466
                    ],
                    [
                       -46.4662,
                       -23.59482
                    ],
                    [
                       -46.49057,
                       -23.58161
                    ],
                    [
                       -46.49443,
                       -23.57901
                    ],
                    [
                       -46.50018,
                       -23.5783
                    ],
                    [
                       -46.50424,
                       -23.57331
                    ],
                    [
                       -46.52023,
                       -23.5761
                    ],
                    [
                       -46.5292,
                       -23.58735
                    ]
                 ]
              ]
           ]
        },
        "address" => %{
           "type" => "Point",
           "coordinates" => [
              -46.474983,
              -23.610245
           ]
        }
      }))
      CodeChallengeBackEnd.Repo.insert(PDV.changeset(%PDV{},%{
         "id" => "40",
         "tradingName" => "Ze Repoe",
         "ownerName" => "Leonardo Cruz",
         "document" => "25.175.276/0001-31",
         "coverageArea" => %{
            "type" => "MultiPolygon",
            "coordinates" => [
               [
                  [
                     [
                        -46.63501,
                        -23.51913
                     ],
                     [
                        -46.66359,
                        -23.5412
                     ],
                     [
                        -46.66518,
                        -23.57269
                     ],
                     [
                        -46.65046,
                        -23.59002
                     ],
                     [
                        -46.65059,
                        -23.60361
                     ],
                     [
                        -46.6514,
                        -23.62113
                     ],
                     [
                        -46.63861,
                        -23.62769
                     ],
                     [
                        -46.63133,
                        -23.62655
                     ],
                     [
                        -46.62626,
                        -23.62699
                     ],
                     [
                        -46.61708,
                        -23.62262
                     ],
                     [
                        -46.57832,
                        -23.60754
                     ],
                     [
                        -46.5818,
                        -23.64106
                     ],
                     [
                        -46.51627,
                        -23.6388
                     ],
                     [
                        -46.51563,
                        -23.63685
                     ],
                     [
                        -46.5135,
                        -23.63578
                     ],
                     [
                        -46.51123,
                        -23.63397
                     ],
                     [
                        -46.50983,
                        -23.63171
                     ],
                     [
                        -46.50643,
                        -23.62813
                     ],
                     [
                        -46.5111,
                        -23.62188
                     ],
                     [
                        -46.50839,
                        -23.60147
                     ],
                     [
                        -46.50477,
                        -23.59945
                     ],
                     [
                        -46.50335,
                        -23.59631
                     ],
                     [
                        -46.50652,
                        -23.57464
                     ],
                     [
                        -46.51376,
                        -23.56384
                     ],
                     [
                        -46.52564,
                        -23.55337
                     ],
                     [
                        -46.53823,
                        -23.54515
                     ],
                     [
                        -46.55966,
                        -23.52669
                     ],
                     [
                        -46.59304,
                        -23.52983
                     ],
                     [
                        -46.59681,
                        -23.53031
                     ],
                     [
                        -46.60851,
                        -23.52231
                     ],
                     [
                        -46.61953,
                        -23.52
                     ],
                     [
                        -46.63501,
                        -23.51913
                     ]
                  ]
               ]
            ]
         },
         "address" => %{
            "type" => "Point",
            "coordinates" => [
               -46.582508,
               -23.563301
            ]
         }
      }))
      conn = get(conn, Routes.pdv_path(conn, :search), %{lng: -46.5141, lat: -23.6164})
      data = json_response(conn, 200)["data"]

      assert data["id"] == pdv.id
    end

    test "render error message when is outside of coverage area", %{conn: conn} do
      conn = get(conn, Routes.pdv_path(conn, :search), %{lng: -23.6617, lat: -46.6124})
      assert json_response(conn, 404)["errors"]["detail"] == "Outside the coverage area"
    end
  end
end
