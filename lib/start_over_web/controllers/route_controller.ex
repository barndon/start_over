defmodule StartOverWeb.RouteController do
  use StartOverWeb, :controller

  def init(conn), do: conn

  def index(conn, _params) do
    routes = StartOver.list_routes()
    render(conn, "routes.json", routes: routes)
  end
end
