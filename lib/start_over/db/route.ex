defmodule StartOver.DB.Route do
  use Ecto.Schema

  import Ecto.Changeset

  alias StartOver.DB
  alias StartOver.Core

  schema("routes") do
    field :oui, :integer
    field :net_id, :integer

    has_one :server, DB.RouteServer

    has_many :euis, DB.EuiPair

    has_many :devaddr_ranges, DB.DevaddrRange

    timestamps()
  end

  def changeset(route, fields \\ %{})

  def changeset(%__MODULE__{} = route, %Core.Route{} = core_route) do
    route_params = %{
      oui: core_route.oui,
      net_id: core_route.net_id,
      server: core_route.server,
      euis: core_route.euis,
      devaddr_ranges: devaddr_range_params(core_route.devaddr_ranges)
    }

    changeset(route, route_params)
  end

  def changeset(%__MODULE__{} = route, fields) do
    route
    |> cast(fields, [:net_id, :oui])
    |> cast_assoc(:devaddr_ranges)
    |> cast_assoc(:euis)
    |> cast_assoc(:server)
  end

  defp devaddr_range_params(ranges) do
    Enum.map(ranges, fn {s, e} -> %{start_addr: s, end_addr: e} end)
  end
end
