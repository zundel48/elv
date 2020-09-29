defmodule Kaytest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Kaytest.Repo,
      # Start the Telemetry supervisor
      KaytestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kaytest.PubSub},
      # Start the Endpoint (http/https)
      KaytestWeb.Endpoint
      # Start a worker by calling: Kaytest.Worker.start_link(arg)
      # {Kaytest.Worker, arg}
    ]

    :ok = :telemetry.detach({Phoenix.Logger, [:phoenix, :socket_connected]})
    :ok = :telemetry.detach({Phoenix.Logger, [:phoenix, :channel_joined]})
    :ok = :telemetry.detach({Phoenix.Logger, [:phoenix, :router_dispatch, :start]})
    :ok = :telemetry.detach({Phoenix.Logger, [:phoenix, :endpoint, :start]})

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kaytest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KaytestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
