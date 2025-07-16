
defmodule InvestorUploadApplication.InvestorsTest do
  use InvestorUploadApplication.DataCase

  alias InvestorUploadApplication.Investors
  alias InvestorUploadApplication.Investors.Investor

  import InvestorUploadApplication.InvestorsFixtures

  @invalid_attrs %{state: nil, first_name: nil, last_name: nil, ssn: nil, date_of_birth: nil, phone_number: nil, street_address: nil, city: nil, street_address2: nil, zip_code: nil, csv_file: nil}

  describe "investors" do
    test "list_investors/0 returns all investors" do
      investor = investor_fixture()
      assert Investors.list_investors() == [investor]
    end

    test "get_investor!/1 returns the investor with given id" do
      investor = investor_fixture()
      assert Investors.get_investor!(investor.id) == investor
    end

    test "create_investor/1 with valid data creates an investor" do
      valid_attrs = %{
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

      assert {:ok, %Investor{} = investor} = Investors.create_investor(valid_attrs)
      assert investor.state == "CA"
      assert investor.first_name == "Jane"
      assert investor.last_name == "Smith"
      assert investor.ssn == "987-65-4321"
      assert investor.date_of_birth == ~D[1985-06-15]
      assert investor.phone_number == "555-123-4567"
      assert investor.street_address == "456 Oak Ave"
      assert investor.city == "Los Angeles"
      assert investor.street_address2 == "Suite 789"
      assert investor.zip_code == "90210"
      assert investor.csv_file == "updated_investors.csv"
    end

    test "create_investor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Investors.create_investor(@invalid_attrs)
    end

    test "update_investor/2 with valid data updates the investor" do
      investor = investor_fixture()
      update_attrs = %{
        state: "NY",
        first_name: "John",
        last_name: "Doe",
        ssn: "123-45-6789",
        date_of_birth: ~D[1980-01-01],
        phone_number: "212-555-1234",
        street_address: "123 Park Ave",
        city: "New York",
        street_address2: "Apt 5B",
        zip_code: "10022",
        csv_file: "new_investors.csv"
      }

      assert {:ok, %Investor{} = investor} = Investors.update_investor(investor, update_attrs)
      assert investor.state == "NY"
      assert investor.first_name == "John"
      assert investor.last_name == "Doe"
      assert investor.ssn == "123-45-6789"
      assert investor.date_of_birth == ~D[1980-01-01]
      assert investor.phone_number == "212-555-1234"
      assert investor.street_address == "123 Park Ave"
      assert investor.city == "New York"
      assert investor.street_address2 == "Apt 5B"
      assert investor.zip_code == "10022"
      assert investor.csv_file == "new_investors.csv"
    end

    test "update_investor/2 with invalid data returns error changeset" do
      investor = investor_fixture()
      assert {:error, %Ecto.Changeset{}} = Investors.update_investor(investor, @invalid_attrs)
      assert investor == Investors.get_investor!(investor.id)
    end

    test "delete_investor/1 deletes the investor" do
      investor = investor_fixture()
      assert {:ok, %Investor{}} = Investors.delete_investor(investor)
      assert_raise Ecto.NoResultsError, fn -> Investors.get_investor!(investor.id) end
    end

    test "change_investor/1 returns a investor changeset" do
      investor = investor_fixture()
      assert %Ecto.Changeset{} = Investors.change_investor(investor)
    end
  end

  describe "validations" do
    test "missing required fields" do
      changeset = Investor.changeset(%Investor{}, %{})
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset, :first_name)
      assert "can't be blank" in errors_on(changeset, :last_name)
      assert "can't be blank" in errors_on(changeset, :ssn)
    end

    test "invalid ssn format" do
      changeset = Investor.changeset(%Investor{}, %{
        first_name: "John",
        last_name: "Doe",
        ssn: "123456789",
        date_of_birth: ~D[1980-01-01],
        phone_number: "555-123-4567",
        street_address: "123 Main St",
        city: "Anytown",
        street_address2: "Apt 1",
        state: "CA",
        zip_code: "12345",
        csv_file: "test.csv"
      })
      refute changeset.valid?
      assert "must be in the format XXX-XX-XXXX" in errors_on(changeset, :ssn)
    end

    test "invalid phone number format" do
      changeset = Investor.changeset(%Investor{}, %{
        first_name: "John",
        last_name: "Doe",
        ssn: "123-45-6789",
        date_of_birth: ~D[1980-01-01],
        phone_number: "5551234567",
        street_address: "123 Main St",
        city: "Anytown",
        street_address2: "Apt 1",
        state: "CA",
        zip_code: "12345",
        csv_file: "test.csv"
      })
      refute changeset.valid?
      assert "must be in the format XXX-XXX-XXXX" in errors_on(changeset, :phone_number)
    end

    test "invalid zip code format" do
      changeset = Investor.changeset(%Investor{}, %{
        first_name: "John",
        last_name: "Doe",
        ssn: "123-45-6789",
        date_of_birth: ~D[1980-01-01],
        phone_number: "555-123-4567",
        street_address: "123 Main St",
        city: "Anytown",
        street_address2: "Apt 1",
        state: "CA",
        zip_code: "1234",
        csv_file: "test.csv"
      })
      refute changeset.valid?
      assert "must be in the format XXXXX or XXXXX-XXXX" in errors_on(changeset, :zip_code)
    end

    test "invalid future date of birth" do
      changeset = Investor.changeset(%Investor{}, %{
        first_name: "John",
        last_name: "Doe",
        ssn: "123-45-6789",
        date_of_birth: Date.add(Date.utc_today(), 1),
        phone_number: "555-123-4567",
        street_address: "123 Main St",
        city: "Anytown",
        street_address2: "Apt 1",
        state: "CA",
        zip_code: "12345",
        csv_file: "test.csv"
      })
      refute changeset.valid?
      assert "must be a valid date in the past" in errors_on(changeset, :date_of_birth)
    end
  end

  defp errors_on(changeset, field) do
    for {^field, {msg, _}} <- changeset.errors, do: msg
  end
end