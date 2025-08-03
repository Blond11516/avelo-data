defmodule AveloData.StationInformationUpdater do
  alias AveloData.StationOccupancy
  alias AveloData.StationStore
  alias AveloData.Gbfs
  alias AveloData.StationOccupancyRepository
  alias Explorer.DataFrame

  require Logger

  def update() do
    with Logger.info("Retrieving GBFS station information"),
         {:ok, gbfs_stations} <- Gbfs.Client.retrieve_station_information(),
         stations = Enum.map(gbfs_stations, &Gbfs.Models.Station.to_station/1),
         Logger.info("Storing stations"),
         :ok <- StationStore.store(stations),
         Logger.info("Retrieving GBFS station status"),
         {:ok, station_statuses} <- Gbfs.Client.retrieve_station_status(),
         station_occupancy = station_status_to_occupancy(station_statuses),
         Logger.info("Storing stations occupancy"),
         :ok <-
           StationOccupancyRepository.store(station_occupancy) do
      :ok
    end
  end

  defp station_status_to_occupancy(station_statuses) when is_list(station_statuses) do
    date =
      Enum.max_by(station_statuses, & &1.last_reported, &NaiveDateTime.after?/2).last_reported

    df =
      DataFrame.new([])
      |> DataFrame.put("reported_at", Enum.map(station_statuses, & &1.last_reported),
        dtype: {:naive_datetime, :millisecond}
      )
      |> DataFrame.put("station_id", Enum.map(station_statuses, & &1.station_id))
      |> DataFrame.put(
        "num_bikes_available",
        Enum.map(station_statuses, & &1.num_bikes_available),
        dtype: {:u, 16}
      )
      |> DataFrame.put(
        "num_docks_available",
        Enum.map(station_statuses, & &1.num_docks_available),
        dtype: {:u, 16}
      )

    %StationOccupancy{
      date: date,
      data: df
    }
  end
end
