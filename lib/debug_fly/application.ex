defmodule DebugFly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DebugFlyWeb.Telemetry,
      DebugFly.Repo,
      {DNSCluster, query: Application.get_env(:debug_fly, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DebugFly.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DebugFly.Finch},
      # Start a worker by calling: DebugFly.Worker.start_link(arg)
      # {DebugFly.Worker, arg},
      # Start to serve requests, typically the last entry
      DebugFlyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DebugFly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DebugFlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
