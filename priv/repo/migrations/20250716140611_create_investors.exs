defmodule InvestorUploadApplication.Repo.Migrations.CreateInvestors do
  use Ecto.Migration

  def change do
    create table(:investors) do
      add :first_name, :string
      add :last_name, :string
      add :ssn, :string
      add :date_of_birth, :date
      add :phone_number, :string
      add :street_address, :string
      add :city, :string
      add :street_address2, :string
      add :state, :string
      add :zip_code, :string
      add :csv_file, :string

      timestamps(type: :utc_datetime)
    end
  end
end
