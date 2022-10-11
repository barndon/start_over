defmodule StartOverGRPC.RouteViewTest do
  use ExUnit.Case

  alias StartOverGRPC.RouteView

  alias Proto.Helium.Config.RouteV1

  import StartOver.Fixtures

  describe "RouteView.route_params/1" do
    test "returns a correct map given a valid HTTP Roaming %Core.Route{}" do
      got = RouteView.route_params(valid_http_roaming_route())

      expected = %{
        oui: 1,
        net_id: 7,
        server: %{
          host: "server1.testdomain.com",
          port: 8888,

          # ProtocolHttpRoamingV1 doesn't support options in this verison.
          protocol: {:http_roaming, %{}}
        },
        euis: [
          %{app_eui: valid_app_eui_integer(), dev_eui: valid_dev_eui_integer()}
        ],
        devaddr_ranges: [
          %{start_addr: 0x0001, end_addr: 0x001F},
          %{start_addr: 0x0030, end_addr: 0x003F}
        ]
      }

      assert(got == expected)
    end

    test "returns a map compatible with a RouteV1 given a valid HTTP Roaming Route" do
      core_route = valid_http_roaming_route()

      bin =
        core_route
        |> RouteView.route_params()
        |> RouteV1.new()
        |> RouteV1.encode()

      assert(is_binary(bin))
    end

    test "returns a correct map given a valid GWMP %Core.Route{}" do
      got = RouteView.route_params(valid_gwmp_route())

      expected = %{
        oui: 1,
        net_id: 7,
        server: %{
          host: "server1.testdomain.com",
          port: 8888,
          protocol:
            {:gwmp,
             %{
               mapping: [
                 %{region: :US915, port: 1000},
                 %{region: :EU868, port: 1001},
                 %{region: :EU433, port: 1002},
                 %{region: :CN470, port: 1003},
                 %{region: :CN779, port: 1004},
                 %{region: :AU915, port: 1005},
                 %{region: :AS923_1, port: 1006},
                 %{region: :KR920, port: 1007},
                 %{region: :IN865, port: 1008},
                 %{region: :AS923_2, port: 1009},
                 %{region: :AS923_3, port: 10010},
                 %{region: :AS923_4, port: 10011},
                 %{region: :AS923_1B, port: 10012},
                 %{region: :CD900_1A, port: 10013}
               ]
             }}
        },
        euis: [
          %{app_eui: valid_app_eui_integer(), dev_eui: valid_dev_eui_integer()}
        ],
        devaddr_ranges: [
          %{start_addr: 0x0001, end_addr: 0x001F},
          %{start_addr: 0x0030, end_addr: 0x003F}
        ]
      }

      assert(got == expected)
    end

    test "returns a map compatible with a RouteV1 given a valid GWMP Route" do
      core_route = valid_gwmp_route()

      bin =
        core_route
        |> RouteView.route_params()
        |> RouteV1.new()
        |> RouteV1.encode()

      assert(is_binary(bin))
    end

    test "returns a correct map given a valid Packet Router %Core.Route{}" do
      got = RouteView.route_params(valid_packet_router_route())

      expected = %{
        oui: 1,
        net_id: 7,
        server: %{
          host: "server1.testdomain.com",
          port: 8888,
          protocol: {:packet_router, %{}}
        },
        euis: [
          %{app_eui: valid_app_eui_integer(), dev_eui: valid_dev_eui_integer()}
        ],
        devaddr_ranges: [
          %{start_addr: 0x00000001, end_addr: 0x0000001F},
          %{start_addr: 0x00000030, end_addr: 0x0000003F}
        ]
      }

      assert(got == expected)
    end

    test "returns a map compatible with a RouteV1 given a valid Packet Router Route" do
      core_route = valid_packet_router_route()

      bin =
        core_route
        |> RouteView.route_params()
        |> RouteV1.new()
        |> RouteV1.encode()

      assert(is_binary(bin))
    end
  end

  # defp valid_core_route do
  #   %Core.Route{
  #     oui: 1,
  #     net_id: 7,
  #     server: %Core.RouteServer{
  #       host: "server1.testdomain.com",
  #       port: 8888,
  #       protocol_opts: %Core.HttpRoamingOpts{
  #         dedupe_window: 1200,
  #         auth_header: "x-helium-auth"
  #       }
  #     },
  #     euis: [
  #       %{app_eui: 100, dev_eui: 200},
  #       %{app_eui: 300, dev_eui: 400}
  #     ],
  #     devaddr_ranges: [
  #       {0x00000001, 0x0000001F},
  #       {0x00000030, 0x0000003F}
  #     ]
  #   }
  # end

  # defp valid_http_roaming_route do
  #   valid_core_route()
  #   |> Map.put(:server, %Core.RouteServer{
  #     host: "server1.testdomain.com",
  #     port: 8888,
  #     protocol_opts: %Core.HttpRoamingOpts{
  #       dedupe_window: 1200,
  #       auth_header: "x-helium-auth"
  #     }
  #   })
  # end

  # defp valid_gwmp_route do
  #   valid_core_route()
  #   |> Map.put(:server, %Core.RouteServer{
  #     host: "server1.testdomain.com",
  #     port: 8888,
  #     protocol_opts: %Core.GwmpOpts{
  #       mapping: [
  #         {:US915, 1000},
  #         {:EU868, 1001},
  #         {:EU433, 1002},
  #         {:CN470, 1003},
  #         {:CN779, 1004},
  #         {:AU915, 1005},
  #         {:AS923_1, 1006},
  #         {:KR920, 1007},
  #         {:IN865, 1008},
  #         {:AS923_2, 1009},
  #         {:AS923_3, 10010},
  #         {:AS923_4, 10011},
  #         {:AS923_1B, 10012},
  #         {:CD900_1A, 10013}
  #       ]
  #     }
  #   })
  # end

  # defp valid_packet_router_route do
  #   valid_core_route()
  #   |> Map.put(:server, %Core.RouteServer{
  #     host: "server1.testdomain.com",
  #     port: 8888,
  #     protocol_opts: %Core.PacketRouterOpts{}
  #   })
  # end
end
