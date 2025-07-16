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
        city: "some city",
        csv_file: "some csv_file",
        date_of_birth: ~D[2025-07-15],
        first_name: "some first_name",
        last_name: "some last_name",
        phone_number: "some phone_number",
        ssn: "some ssn",
        state: "some state",
        street_address: "some street_address",
        street_address2: "some street_address2",
        zip_code: "some zip_code"
      })
      |> InvestorUploadApplication.Investors.create_investor()

    investor
  end
end
