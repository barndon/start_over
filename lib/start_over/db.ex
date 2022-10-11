defmodule StartOver.DB do
  alias StartOver.Core
  alias StartOver.DB
  alias StartOver.Repo

  def list_routes do
    DB.Route
    |> Repo.all()
    |> Repo.preload([:devaddr_ranges, :euis, :server])
  end

  def list_organizations do
    DB.Organization
    |> Repo.all()
    |> Enum.map(&organization_preloads/1)
  end

  def create_organization(params) do
    result =
      %DB.Organization{}
      |> DB.Organization.changeset(params)
      |> Repo.insert()

    case result do
      {:ok, _} ->
        DB.UpdateNotifier.notify_cast()
        :ok

      {:error, e} ->
        {:error, e}
    end
  end

  def get_organization(oui) do
    DB.Organization
    |> Repo.get(oui)
    |> organization_preloads()
  end

  def update_organization(%Core.Organization{} = new_org) do
    current =
      case Repo.get(DB.Organization, new_org.oui) do
        nil ->
          %DB.Organization{oui: new_org.oui}

        existing_org ->
          existing_org
          |> organization_preloads()
      end

    result =
      current
      |> DB.Organization.changeset(new_org)
      |> Repo.insert_or_update()

    case result do
      {:ok, _} ->
        DB.UpdateNotifier.notify_cast()
        :ok

      {:error, e} ->
        {:error, e}
    end
  end

  def delete_organization(oui) when is_integer(oui) do
    current = Repo.get!(DB.Organization, oui)

    case Repo.delete(current) do
      {:ok, _} ->
        DB.UpdateNotifier.notify_cast()
        :ok

      {:error, e} ->
        {:error, e}
    end
  end

  defp organization_preloads(nil), do: nil

  defp organization_preloads({:ok, org}) do
    organization_preloads(org)
  end

  defp organization_preloads(%DB.Organization{} = org) do
    Repo.preload(org, [:routes, [routes: [:server, :devaddr_ranges, :euis]]])
  end

  defp organization_preloads({:error, _} = error), do: error
end
