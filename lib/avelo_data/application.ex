defmodule AveloData.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        AveloDataWeb.Telemetry,
        AveloData.StationUpdateManager,
        {DNSCluster, query: Application.get_env(:avelo_data, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: AveloData.PubSub},
        # Start a worker by calling: AveloData.Worker.start_link(arg)
        # {AveloData.Worker, arg},
        # Start to serve requests, typically the last entry
        AveloDataWeb.Endpoint
      ]
      |> append_if(
        Application.get_env(:hilostory, :env) != :test,
        {Tz.UpdatePeriodically, [interval_in_days: 7]}
      )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AveloData.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AveloDataWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp append_if(list, condition, item) do
    if condition, do: list ++ [item], else: list
  end
end
