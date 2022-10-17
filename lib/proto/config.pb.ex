defmodule Proto.Helium.Config.DevaddrRangeV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :start_addr, 1, type: :uint64, json_name: "startAddr"
  field :end_addr, 2, type: :uint64, json_name: "endAddr"
end

defmodule Proto.Helium.Config.EuiV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :app_eui, 1, type: :uint64, json_name: "appEui"
  field :dev_eui, 2, type: :uint64, json_name: "devEui"
end

defmodule Proto.Helium.Config.ProtocolPacketRouterV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Proto.Helium.Config.ProtocolGwmpMappingV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :region, 1, type: Proto.Helium.Region, enum: true
  field :port, 2, type: :uint32
end

defmodule Proto.Helium.Config.ProtocolGwmpV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :mapping, 1, repeated: true, type: Proto.Helium.Config.ProtocolGwmpMappingV1
end

defmodule Proto.Helium.Config.ProtocolHttpRoamingV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Proto.Helium.Config.ServerV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  oneof(:protocol, 0)

  field :host, 1, type: :bytes
  field :port, 2, type: :uint32

  field :packet_router, 3,
    type: Proto.Helium.Config.ProtocolPacketRouterV1,
    json_name: "packetRouter",
    oneof: 0

  field :gwmp, 4, type: Proto.Helium.Config.ProtocolGwmpV1, oneof: 0

  field :http_roaming, 5,
    type: Proto.Helium.Config.ProtocolHttpRoamingV1,
    json_name: "httpRoaming",
    oneof: 0
end

defmodule Proto.Helium.Config.RouteV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :net_id, 1, type: :uint64, json_name: "netId"

  field :devaddr_ranges, 2,
    repeated: true,
    type: Proto.Helium.Config.DevaddrRangeV1,
    json_name: "devaddrRanges"

  field :euis, 3, repeated: true, type: Proto.Helium.Config.EuiV1
  field :oui, 4, type: :uint64
  field :server, 5, type: Proto.Helium.Config.ServerV1
  field :max_copies, 6, type: :uint32, json_name: "maxCopies"
end

defmodule Proto.Helium.Config.RoutesReqV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3
end

defmodule Proto.Helium.Config.RoutesResV1 do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :routes, 1, repeated: true, type: Proto.Helium.Config.RouteV1
end

defmodule Proto.Helium.Config.ConfigService.Service do
  @moduledoc false
  use GRPC.Service, name: "helium.config.config_service", protoc_gen_elixir_version: "0.10.0"

  rpc(:route_updates, Proto.Helium.Config.RoutesReqV1, stream(Proto.Helium.Config.RoutesResV1))
end

defmodule Proto.Helium.Config.ConfigService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Proto.Helium.Config.ConfigService.Service
end
