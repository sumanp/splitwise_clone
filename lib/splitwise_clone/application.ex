defmodule SplitwiseClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SplitwiseCloneWeb.Telemetry,
      SplitwiseClone.Repo,
      {AshAuthentication.Supervisor, otp_app: :splitwise_clone},
      {DNSCluster, query: Application.get_env(:splitwise_clone, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SplitwiseClone.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SplitwiseClone.Finch},
      # Start a worker by calling: SplitwiseClone.Worker.start_link(arg)
      # {SplitwiseClone.Worker, arg},
      # Start to serve requests, typically the last entry
      SplitwiseCloneWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SplitwiseClone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SplitwiseCloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
