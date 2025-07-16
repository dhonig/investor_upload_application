
defmodule InvestorUploadApplicationWeb.InvestorControllerTest do
  use InvestorUploadApplicationWeb.ConnCase

  import InvestorUploadApplication.InvestorsFixtures

  @create_attrs %{
    first_name: "Jane",
    last_name: "Smith",
    ssn: "987-65-4321",
    date_of_birth: ~D[1985-06-15],
    phone_number: "555-123-4567",
    street_address: "456 Oak Ave",
    city: "Los Angeles",
    street_address2: "Suite 789",
    state: "CA",
    zip_code: "90210",
    csv_file: "updated_investors.csv"
  }
  @update_attrs %{
    first_name: "John",
    last_name: "Doe",
    ssn: "123-45-6789",
    date_of_birth: ~D[1980-01-01],
    phone_number: "212-555-1234",
    street_address: "123 Park Ave",
    city: "New York",
    street_address2: "Apt 5B",
    state: "NY",
    zip_code: "10022",
    csv_file: "new_investors.csv"
  }
  @invalid_attrs %{state: nil, first_name: nil, last_name: nil, ssn: nil, date_of_birth: nil, phone_number: nil, street_address: nil, city: nil, street_address2: nil, zip_code: nil, csv_file: nil}

  describe "index" do
    test "lists all investors", %{conn: conn} do
      conn = get(conn, ~p"/investors")
      assert html_response(conn, 200) =~ "Listing Investors"
    end
  end

  describe "new investor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/investors/new")
      assert html_response(conn, 200) =~ "New Investor"
    end
  end

  describe "create investor" do
    test "redirects to show when data is valid", %{conn: conn} do
      upload = %Plug.Upload{
        path: "test/support/fixtures/test.csv",
        filename: "test.csv"
      }
      attrs = Map.put(@create_attrs, :csv_file, upload)

      conn = post(conn, ~p"/investors", investor: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/investors/#{id}"

      conn = get(conn, ~p"/investors/#{id}")
      assert html_response(conn, 200) =~ "Investor #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/investors", investor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Investor"
    end
  end

  describe "edit investor" do
    setup [:create_investor]

    test "renders form for editing chosen investor", %{conn: conn, investor: investor} do
      conn = get(conn, ~p"/investors/#{investor}/edit")
      assert html_response(conn, 200) =~ "Edit Investor"
    end
  end

  describe "update investor" do
    setup [:create_investor]

    test "redirects when data is valid", %{conn: conn, investor: investor} do
      upload = %Plug.Upload{
        path: "test/support/fixtures/test.csv",
        filename: "test.csv"
      }
      attrs = Map.put(@update_attrs, :csv_file, upload)

      conn = put(conn, ~p"/investors/#{investor}", investor: attrs)
      assert redirected_to(conn) == ~p"/investors/#{investor}"

      conn = get(conn, ~p"/investors/#{investor}")
      assert html_response(conn, 200) =~ "John"
    end

    test "renders errors when data is invalid", %{conn: conn, investor: investor} do
      conn = put(conn, ~p"/investors/#{investor}", investor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Investor"
    end
  end

  describe "delete investor" do
    setup [:create_investor]

    test "deletes chosen investor", %{conn: conn, investor: investor} do
      conn = delete(conn, ~p"/investors/#{investor}")
      assert redirected_to(conn) == ~p"/investors"

      assert_error_sent 404, fn ->
        get(conn, ~p"/investors/#{investor}")
      end
    end
  end

  defp create_investor(_) do
    investor = investor_fixture()
    %{investor: investor}
  end
end