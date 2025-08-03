defmodule AveloData.StationInformationUpdater do
  alias AveloData.Station
  alias AveloData.StationOccupancy
  alias AveloData.StationStore
  alias AveloData.Gbfs
  alias AveloData.StationOccupancyRepository

  require Logger

  def update() do
    with Logger.info("Retrieving GBFS station information"),
         {:ok, gbfs_stations} <- Gbfs.Client.retrieve_station_information(),
         stations = Enum.map(gbfs_stations, &Station.from_gbfs_station/1),
         Logger.info("Storing stations"),
         :ok <- StationStore.store(stations),
         Logger.info("Retrieving GBFS station status"),
         {:ok, station_statuses} <- Gbfs.Client.retrieve_station_status(),
         station_occupancy = StationOccupancy.from_gbfs_status(station_statuses),
         Logger.info("Storing stations occupancy"),
         :ok <-
           StationOccupancyRepository.store(station_occupancy) do
      :ok
    end
  end
end
