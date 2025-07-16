defmodule InvestorUploadApplicationWeb.InvestorController do
  use InvestorUploadApplicationWeb, :controller

  alias InvestorUploadApplication.Investors
  alias InvestorUploadApplication.Investors.Investor

  def index(conn, _params) do
    investors = Investors.list_investors()
    render(conn, :index, investors: investors)
  end

  def new(conn, _params) do
    changeset = Investors.change_investor(%Investor{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"investor" => investor_params}) do
    investor_params = process_uploaded_file(investor_params)

    case Investors.create_investor(investor_params) do
      {:ok, investor} ->
        conn
        |> put_flash(:info, "Investor created successfully.")
        |> redirect(to: ~p"/investors/#{investor}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    investor = Investors.get_investor!(id)
    render(conn, :show, investor: investor)
  end

  def edit(conn, %{"id" => id}) do
    investor = Investors.get_investor!(id)
    changeset = Investors.change_investor(investor)
    render(conn, :edit, investor: investor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "investor" => investor_params}) do
    investor = Investors.get_investor!(id)
    investor_params = process_uploaded_file(investor_params)

    case Investors.update_investor(investor, investor_params) do
      {:ok, investor} ->
        conn
        |> put_flash(:info, "Investor updated successfully.")
        |> redirect(to: ~p"/investors/#{investor}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, investor: investor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    investor = Investors.get_investor!(id)
    {:ok, _investor} = Investors.delete_investor(investor)

    conn
    |> put_flash(:info, "Investor deleted successfully.")
    |> redirect(to: ~p"/investors")
  end

  defp process_uploaded_file(%{"csv_file" => %Plug.Upload{} = csv_upload} = params) do
    case upload_file(csv_upload) do
      {:ok, filename} -> Map.put(params, "csv_file", filename)
      {:error, _} -> params
    end
  end

  defp process_uploaded_file(params), do: params

  defp upload_file(%Plug.Upload{path: path, filename: filename}) do
    File.mkdir_p!("priv/static/uploads")

    # Preserve the original filename but ensure it's secure and unique
    sanitized_filename = sanitize_filename(filename)
    timestamp = :os.system_time(:millisecond)
    new_filename = "#{timestamp}_#{sanitized_filename}"
    new_path = Path.join("priv/static/uploads", new_filename)

    case File.cp(path, new_path) do
      :ok -> {:ok, filename}
      {:error, _} = error -> error
    end
  end

  # Sanitize the filename to prevent security issues
  defp sanitize_filename(filename) do
    filename
    |> String.replace(~r/[^a-zA-Z0-9_.-]/, "")
    |> String.replace(~r/^\.|\.$/, "")
  end
end
