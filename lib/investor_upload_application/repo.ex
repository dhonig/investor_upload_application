defmodule InvestorUploadApplication.Repo do
  use Ecto.Repo,
    otp_app: :investor_upload_application,
    adapter: Ecto.Adapters.Postgres
end
