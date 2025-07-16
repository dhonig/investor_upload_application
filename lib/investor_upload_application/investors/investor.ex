defmodule InvestorUploadApplication.Investors.Investor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "investors" do
    field :state, :string
    field :first_name, :string
    field :last_name, :string
    field :ssn, :string
    field :date_of_birth, :date
    field :phone_number, :string
    field :street_address, :string
    field :city, :string
    field :street_address2, :string
    field :zip_code, :string
    field :csv_file, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(investor, attrs) do
    investor
    |> cast(attrs, [:first_name, :last_name, :ssn, :date_of_birth, :phone_number, :street_address, :city, :street_address2, :state, :zip_code, :csv_file])
    |> validate_required([:first_name, :last_name, :ssn, :date_of_birth, :phone_number, :street_address, :city, :street_address2, :state, :zip_code, :csv_file])
    |> validate_format(:ssn, ~r/^\d{3}-\d{2}-\d{4}$/, message: "must be in the format XXX-XX-XXXX")
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/, message: "must be in the format XXX-XXX-XXXX")
    |> validate_format(:zip_code, ~r/^\d{5}(-\d{4})?$/, message: "must be in the format XXXXX or XXXXX-XXXX")
    |> validate_date(:date_of_birth)
  end


  defp validate_date(changeset, field) do
    validate_change(changeset, field, fn _, date ->
      today = Date.utc_today()
      case Date.compare(date, today) do
        :gt -> [{field, "must be a valid date in the past"}]
        _ -> []
      end
     end)
   end



  end
