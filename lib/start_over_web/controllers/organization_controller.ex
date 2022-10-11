defmodule StartOverWeb.OrganizationController do
  use StartOverWeb, :controller

  alias StartOver.Core

  def init(conn), do: conn

  def index(conn, _params) do
    orgs = StartOver.list_organizations()
    render(conn, "organizations.json", organizations: orgs)
  end

  def create(conn, %{"organization" => params}) do
    params
    |> Core.Organization.from_web()
    |> StartOver.create_organization()

    conn
    |> put_status(201)
    |> json(%{status: "success"})
  end

  def update(conn, %{"oui" => oui, "organization" => updated_org}) do
    result =
      updated_org
      |> Core.Organization.from_web()
      |> Map.put(:oui, oui)
      |> StartOver.update_organization()

    case result do
      :ok ->
        conn
        |> put_status(200)
        |> json(%{status: "success"})

      {:error, e} ->
        {:error, e}
    end
  end
end
