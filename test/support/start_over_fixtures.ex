defmodule StartOver.Fixtures do
  alias StartOver.Core

  def valid_app_eui_integer do
    0xBEEEEEEE_EEEEEEEF
  end

  def valid_dev_eui_integer do
    0xFAAAAAAA_AAAAAACE
  end

  def valid_core_organization do
    %Core.Organization{
      oui: 1,
      owner_wallet_id: "owners_wallet_id",
      payer_wallet_id: "payers_wallet_id",
      routes: [
        valid_http_roaming_route(),
        valid_gwmp_route(),
        valid_packet_router_route()
      ]
    }
  end

  def valid_core_route do
    %Core.Route{
      oui: 1,
      net_id: 7,
      server: %Core.RouteServer{
        host: "server1.testdomain.com",
        port: 8888,
        protocol_opts: %Core.HttpRoamingOpts{
          dedupe_window: 1200,
          auth_header: "x-helium-auth"
        }
      },
      euis: [
        %{app_eui: valid_app_eui_integer(), dev_eui: valid_dev_eui_integer()}
      ],
      devaddr_ranges: [
        {0x0001, 0x001F},
        {0x0030, 0x003F}
      ]
    }
  end

  def valid_http_roaming_route do
    valid_core_route()
    |> Map.put(:server, %Core.RouteServer{
      host: "server1.testdomain.com",
      port: 8888,
      protocol_opts: %Core.HttpRoamingOpts{
        dedupe_window: 1200,
        auth_header: "x-helium-auth"
      }
    })
  end

  def valid_gwmp_route do
    valid_core_route()
    |> Map.put(:server, %Core.RouteServer{
      host: "server1.testdomain.com",
      port: 8888,
      protocol_opts: %Core.GwmpOpts{
        mapping: [
          {:US915, 1000},
          {:EU868, 1001},
          {:EU433, 1002},
          {:CN470, 1003},
          {:CN779, 1004},
          {:AU915, 1005},
          {:AS923_1, 1006},
          {:KR920, 1007},
          {:IN865, 1008},
          {:AS923_2, 1009},
          {:AS923_3, 10010},
          {:AS923_4, 10011},
          {:AS923_1B, 10012},
          {:CD900_1A, 10013}
        ]
      }
    })
  end

  def valid_packet_router_route do
    valid_core_route()
    |> Map.put(:server, %Core.RouteServer{
      host: "server1.testdomain.com",
      port: 8888,
      protocol_opts: %Core.PacketRouterOpts{}
    })
  end
end
