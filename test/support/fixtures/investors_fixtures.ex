defmodule InvestorUploadApplication.InvestorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InvestorUploadApplication.Investors` context.
  """

  @doc """
  Generate a investor.
  """
  def investor_fixture(attrs \\ %{}) do
    {:ok, investor} =
      attrs
      |> Enum.into(%{
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
      })
      |> InvestorUploadApplication.Investors.create_investor()

    investor
  end
end
