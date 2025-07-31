defmodule AveloData.StationUpdateManager do
  use GenServer

  require Logger

  @update_interval_ms :timer.minutes(15)

  def start_link(_) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    Logger.info("Initializing #{__MODULE__}")
    {:ok, nil, {:continue, :start_update_loop}}
  end

  @impl true
  def handle_continue(:start_update_loop, state) do
    update()

    {:noreply, state}
  end

  @impl true
  def handle_info(:update_stations, state) do
    update()
    {:noreply, state}
  end

  defp update() do
    Logger.info("Updating station data")
    AveloData.StationInformationUpdater.update()

    Logger.info(
      "Station data updated successfully. Will update again in #{@update_interval_ms} ms"
    )

    Process.send_after(self(), :update_stations, @update_interval_ms)
  end
end
