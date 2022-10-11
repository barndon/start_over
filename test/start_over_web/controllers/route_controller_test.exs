defmodule StartOverWeb.RouteControllerTest do
  use StartOverWeb.ConnCase

  alias StartOver.DB

  import StartOver.Fixtures

  describe "index" do
    test "returns an empty list when no routes exist", %{conn: conn} do
      conn = get(conn, Routes.route_path(conn, :index))
      assert json_response(conn, 200) == %{"routes" => []}
    end

    test "returns routes when routes exist", %{conn: conn} do
      core_route = valid_core_organization()
      :ok = DB.create_organization(core_route)

      conn = get(conn, Routes.route_path(conn, :index))
      assert %{"routes" => routes} = json_response(conn, 200)
      assert length(routes) == length(core_route.routes)
    end
  end
end
