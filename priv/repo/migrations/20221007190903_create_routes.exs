defmodule StartOver.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  def change do
    create table("organizations", primary_key: false) do
      add :oui, :integer, primary_key: true
      add :owner_wallet_id, :string, null: false
      add :payer_wallet_id, :string, null: false

      timestamps()
    end

    create table("routes") do
      add :oui, references(:organizations, column: :oui, on_delete: :delete_all)
      add :net_id, :integer, null: false

      timestamps()
    end

    create table("route_eui_pairs") do
      add :route_id, references(:routes, on_delete: :delete_all)
      add :app_eui, :numeric, null: false
      add :dev_eui, :numeric, null: false

      timestamps()
    end

    create table("route_devaddr_ranges") do
      add :route_id, references(:routes, on_delete: :delete_all)
      add :start_addr, :bigint, null: false
      add :end_addr, :bigint, null: false

      timestamps()
    end

    create table("route_servers") do
      add :route_id, references(:routes, on_delete: :delete_all), primary_key: true
      add :host, :string, null: false
      add :port, :integer, null: false
      add :protocol_opts, :map, null: false

      timestamps()
    end
  end
end
