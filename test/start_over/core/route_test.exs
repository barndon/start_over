defmodule StartOver.Core.RouteTest do
  use ExUnit.Case

  alias Proto.Helium.Config.RouteV1
  alias StartOver.Core.Route
  alias StartOver.Core.RouteServer
  alias StartOver.Core.HttpRoamingOpts
  alias StartOver.Core.GwmpOpts
  alias StartOver.Core.PacketRouterOpts

  describe "Route.from_web/1" do
    test "can decode an HTTP Roaming Route from JSON params" do
      json_params = %{
        "net_id" => 7,
        "oui" => 1,
        "server" => %{
          "host" => "server1.testdomain.com",
          "port" => 1000,
          "protocol" => %{
            "type" => "http_roaming",
            "dedupe_window" => 1200,
            "auth_header" => "x-helium-auth"
          }
        },
        "euis" => [
          %{"app_eui" => 100, "dev_eui" => 200},
          %{"app_eui" => 300, "dev_eui" => 400}
        ],
        "devaddr_ranges" => [
          %{"start_addr" => "0000000000000001", "end_addr" => "00000000000000FF"},
          %{"start_addr" => "0000000000000200", "end_addr" => "00000000000002FF"}
        ]
      }

      got = Route.from_web(json_params)

      expected = %Route{
        oui: 1,
        net_id: 7,
        server: %RouteServer{
          host: "server1.testdomain.com",
          port: 1000,
          protocol_opts: %HttpRoamingOpts{
            dedupe_window: 1200,
            auth_header: "x-helium-auth"
          }
        },
        euis: [
          %{app_eui: 100, dev_eui: 200},
          %{app_eui: 300, dev_eui: 400}
        ],
        devaddr_ranges: [
          {1, 255},
          {512, 767}
        ]
      }

      assert(got == expected)
    end
  end

  describe "Route.oui_from_web/1" do
    test "converts string arguments from hex to integer" do
      got = Route.oui_from_web("00FF")

      expected = 255

      assert(got == expected)
    end
  end

  describe "Route.net_id_from_web/1" do
    test "converts string arguments from hex to integer" do
      got = Route.net_id_from_web("00FF")

      expected = 255

      assert(got == expected)
    end

    test "accepts integer arguments as-is" do
      got = Route.net_id_from_web(255)

      expected = 255

      assert(got == expected)
    end
  end

  describe "Route.devaddr_range_from_web/1" do
    test "converts string arguments from hex to integer" do
      got =
        Route.devaddr_range_from_web(%{
          "start_addr" => "0000000000000001",
          "end_addr" => "00000000000000FF"
        })

      expected = {1, 255}

      assert(got == expected)
    end

    test "accepts integer arguments as-is" do
      got = Route.devaddr_range_from_web(%{"start_addr" => 0x1, "end_addr" => 0xFF})

      expected = {1, 255}

      assert(got == expected)
    end
  end

  describe "Route.eui_pair_from_web/1" do
    test "converts string arguments from hex to integer" do
      got = Route.eui_pair_from_web(%{"app_eui" => "00FF", "dev_eui" => "00FE"})

      expected = %{app_eui: 255, dev_eui: 254}

      assert(got == expected)
    end

    test "accepts integer arguments as-is" do
      got = Route.eui_pair_from_web(%{"app_eui" => 255, "dev_eui" => 254})

      expected = %{app_eui: 255, dev_eui: 254}

      assert(got == expected)
    end
  end

  describe "Route.from_proto/1" do
    test "can decode an HTTP Roaming RouteV1 protobuf" do
      bin =
        %{
          net_id: 7,
          oui: 1,
          server: %{
            host: "server1.testdomain.com",
            port: 1000,
            protocol: {:http_roaming, %{dummy_arg: true}}
          },
          euis: [
            %{app_eui: 100, dev_eui: 200},
            %{app_eui: 300, dev_eui: 400}
          ],
          devaddr_ranges: [
            %{start_addr: 0x00000001, end_addr: 0x000000FF},
            %{start_addr: 0x00000200, end_addr: 0x000002FF}
          ]
        }
        |> RouteV1.new()
        |> RouteV1.encode()

      got =
        bin
        |> RouteV1.decode()
        |> Route.from_proto()

      expected = %Route{
        oui: 1,
        net_id: 7,
        server: %RouteServer{
          host: "server1.testdomain.com",
          port: 1000,
          protocol_opts: %HttpRoamingOpts{}
        },
        euis: [
          %{app_eui: 100, dev_eui: 200},
          %{app_eui: 300, dev_eui: 400}
        ],
        devaddr_ranges: [
          {0x00000001, 0x000000FF},
          {0x00000200, 0x000002FF}
        ]
      }

      assert(got == expected)
    end

    test "can decode a GWMP RouteV1 protobuf" do
      bin =
        %{
          net_id: 7,
          oui: 1,
          server: %{
            host: "server1.testdomain.com",
            port: 1000,
            protocol:
              {:gwmp, %{mapping: [%{region: :US915, port: 1000}, %{region: :EU868, port: 2000}]}}
          },
          euis: [
            %{app_eui: 100, dev_eui: 200},
            %{app_eui: 300, dev_eui: 400}
          ],
          devaddr_ranges: [
            %{start_addr: 0x00000001, end_addr: 0x000000FF},
            %{start_addr: 0x00000200, end_addr: 0x000002FF}
          ]
        }
        |> RouteV1.new()
        |> RouteV1.encode()

      got =
        bin
        |> RouteV1.decode()
        |> Route.from_proto()

      expected = %Route{
        oui: 1,
        net_id: 7,
        server: %RouteServer{
          host: "server1.testdomain.com",
          port: 1000,
          protocol_opts: %GwmpOpts{
            mapping: [
              {:US915, 1000},
              {:EU868, 2000}
            ]
          }
        },
        euis: [
          %{app_eui: 100, dev_eui: 200},
          %{app_eui: 300, dev_eui: 400}
        ],
        devaddr_ranges: [
          {0x00000001, 0x000000FF},
          {0x00000200, 0x000002FF}
        ]
      }

      assert(got == expected)
    end

    test "can decode a Packet Router RouteV1 protobuf" do
      bin =
        %{
          net_id: 7,
          oui: 1,
          server: %{
            host: "server1.testdomain.com",
            port: 1000,
            protocol: {:packet_router, %{dummy_arg: true}}
          },
          euis: [
            %{app_eui: 100, dev_eui: 200},
            %{app_eui: 300, dev_eui: 400}
          ],
          devaddr_ranges: [
            %{start_addr: 0x00000001, end_addr: 0x000000FF},
            %{start_addr: 0x00000200, end_addr: 0x000002FF}
          ]
        }
        |> RouteV1.new()
        |> RouteV1.encode()

      got =
        bin
        |> RouteV1.decode()
        |> Route.from_proto()

      expected = %Route{
        oui: 1,
        net_id: 7,
        server: %RouteServer{
          host: "server1.testdomain.com",
          port: 1000,
          protocol_opts: %PacketRouterOpts{}
        },
        euis: [
          %{app_eui: 100, dev_eui: 200},
          %{app_eui: 300, dev_eui: 400}
        ],
        devaddr_ranges: [
          {0x00000001, 0x000000FF},
          {0x00000200, 0x000002FF}
        ]
      }

      assert(got == expected)
    end
  end
end
