defmodule StartOver.DBTest do
  use StartOver.DataCase, async: false

  alias StartOver.DB

  import StartOver.Fixtures

  describe "DB.create_organization/1" do
    test "inserts database records given a valid Core.Organization" do
      assert(organization_tables_empty())

      valid_org = valid_core_organization()
      assert(:ok == DB.create_organization(valid_org))

      assert(1 == length(Repo.all(DB.Organization)))
      assert(3 == length(Repo.all(DB.Route)))
      assert(3 == length(Repo.all(DB.EuiPair)))
      assert(6 == length(Repo.all(DB.DevaddrRange)))
      assert(3 == length(Repo.all(DB.RouteServer)))
    end
  end

  describe "DB.get_organization/1" do
    test "returns a DB.Organization with fields correctly preloaded when a record exists with the given OUI" do
      valid_org = valid_core_organization()
      DB.create_organization(valid_org)

      assert(
        %DB.Organization{
          routes: [
            %DB.Route{
              server: %DB.RouteServer{},
              euis: [
                %DB.EuiPair{}
              ],
              devaddr_ranges: [
                %DB.DevaddrRange{},
                %DB.DevaddrRange{}
              ]
            },
            %DB.Route{
              server: %DB.RouteServer{},
              euis: [
                %DB.EuiPair{}
              ],
              devaddr_ranges: [
                %DB.DevaddrRange{},
                %DB.DevaddrRange{}
              ]
            },
            %DB.Route{
              server: %DB.RouteServer{},
              euis: [
                %DB.EuiPair{}
              ],
              devaddr_ranges: [
                %DB.DevaddrRange{},
                %DB.DevaddrRange{}
              ]
            }
          ]
        } = DB.get_organization(valid_org.oui)
      )
    end

    test "returns nil when no record exists with the given OUI" do
      assert(nil == DB.get_organization(1))
    end
  end

  describe "DB.delete_organization/1" do
    test "removes records from all relations" do
      assert(organization_tables_empty())
      valid_org = valid_core_organization()
      assert(:ok == DB.create_organization(valid_org))

      assert(1 == length(Repo.all(DB.Organization)))
      assert(3 == length(Repo.all(DB.Route)))
      assert(3 == length(Repo.all(DB.EuiPair)))
      assert(6 == length(Repo.all(DB.DevaddrRange)))
      assert(3 == length(Repo.all(DB.RouteServer)))

      :ok = DB.delete_organization(valid_org.oui)

      assert(organization_tables_empty())
    end
  end

  defp organization_tables_empty do
    [] == Repo.all(DB.Organization) &&
      [] == Repo.all(DB.Route) &&
      [] == Repo.all(DB.EuiPair) &&
      [] == Repo.all(DB.DevaddrRange) &&
      [] == Repo.all(DB.RouteServer)
  end
end
