defmodule StartOverWeb.OrganizationControllerTest do
  use StartOverWeb.ConnCase

  alias StartOver.DB
  alias StartOver.Repo

  alias StartOverWeb.OrganizationView

  import StartOver.Fixtures

  describe "index" do
    test "returns an empty list when no organizations exist", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))
      assert json_response(conn, 200) == %{"organizations" => []}
    end

    test "returns a list of organizations when organizations exist", %{conn: conn} do
      valid_core_organization()
      |> DB.create_organization()

      conn = get(conn, Routes.organization_path(conn, :index))
      assert %{"organizations" => orgs} = json_response(conn, 200)
      assert 1 == length(orgs)
    end
  end

  describe "create organization" do
    test "returns 201 given valid inputs", %{conn: conn} do
      assert [] == Repo.all(DB.Organization)

      valid_org = valid_core_organization()
      valid_json = OrganizationView.organization_json(valid_org)

      conn = post(conn, Routes.organization_path(conn, :create), %{organization: valid_json})

      assert json_response(conn, 201) == %{"status" => "success"}
    end
  end

  describe "update organization" do
    test "returns 200 given valid inputs", %{conn: conn} do
      valid_org = valid_core_organization()
      :ok = DB.create_organization(valid_org)

      updated_org =
        valid_org
        |> Map.put(:owner_wallet_id, "updated_wallet_id")

      updated_json = OrganizationView.organization_json(updated_org)

      conn =
        put(conn, Routes.organization_path(conn, :update, valid_org.oui), %{
          organization: updated_json
        })

      assert json_response(conn, 200) == %{"status" => "success"}
    end
  end
end
