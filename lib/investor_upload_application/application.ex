defmodule InvestorUploadApplication.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InvestorUploadApplicationWeb.Telemetry,
      InvestorUploadApplication.Repo,
      {DNSCluster, query: Application.get_env(:investor_upload_application, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InvestorUploadApplication.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InvestorUploadApplication.Finch},
      # Start a worker by calling: InvestorUploadApplication.Worker.start_link(arg)
      # {InvestorUploadApplication.Worker, arg},
      # Start to serve requests, typically the last entry
      InvestorUploadApplicationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvestorUploadApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvestorUploadApplicationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
