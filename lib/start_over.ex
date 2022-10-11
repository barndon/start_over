defmodule StartOver do
  @moduledoc """
  StartOver keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias StartOver.Core
  alias StartOver.DB

  def list_routes do
    DB.list_routes()
    |> Enum.map(&Core.Route.from_db/1)
  end

  def list_organizations do
    DB.list_organizations()
    |> Enum.map(&Core.Organization.from_db/1)
  end

  def get_organization(oui) do
    oui
    |> DB.get_organization()
    |> Core.Organization.from_db()
  end

  def create_organization(%Core.Organization{} = org) do
    :ok = DB.create_organization(org)
  end

  def update_organization(%Core.Organization{} = updated_org) do
    :ok = DB.update_organization(updated_org)
  end
end
