defmodule Proto.Helium.Region do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  field :US915, 0
  field :EU868, 1
  field :EU433, 2
  field :CN470, 3
  field :CN779, 4
  field :AU915, 5
  field :AS923_1, 6
  field :KR920, 7
  field :IN865, 8
  field :AS923_2, 9
  field :AS923_3, 10
  field :AS923_4, 11
  field :AS923_1B, 12
  field :CD900_1A, 13
end
