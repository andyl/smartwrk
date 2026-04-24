defmodule Smartwrk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmartwrkWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:smartwrk, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Smartwrk.PubSub},
      # Start a worker by calling: Smartwrk.Worker.start_link(arg)
      # {Smartwrk.Worker, arg},
      # Start to serve requests, typically the last entry
      SmartwrkWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Smartwrk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartwrkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
