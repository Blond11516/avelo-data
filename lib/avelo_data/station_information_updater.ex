defmodule AveloData.StationInformationUpdater do
  alias AveloData.Models

  require Logger

  def update() do
    {:ok, stations} = AveloData.GbfsClient.retrieve_station_informations()
    Enum.each(stations, fn station -> {:ok, _} = upsert_station(station) end)

    {:ok, station_statuses} = AveloData.GbfsClient.retrieve_station_statuses()

    Enum.each(station_statuses, fn station_status ->
      {:ok, _} = upsert_station_status(station_status)
    end)

    :ok
  end

  defp upsert_station(%Models.Station{} = station) do
    station_params = Map.from_struct(station)

    {:ok, _} =
      %AveloDataInfrastructure.StationSchema{}
      |> Ecto.Changeset.cast(
        station_params,
        [
          :ride_code_support,
          :address,
          :capacity,
          :groups,
          :is_charging_station,
          :altitude,
          :geolocation,
          :name,
          :nearby_distance,
          :obcn,
          :physical_configuration,
          :post_code,
          :rental_methods,
          :rental_uris,
          :short_name,
          :station_id
        ],
        empty_values: []
      )
      |> AveloData.Repo.insert(on_conflict: :replace_all, conflict_target: :station_id)
  end

  defp upsert_station_status(%Models.StationStatus{} = station_status) do
    station_params =
      station_status
      |> Map.from_struct()
      |> Map.put(
        :num_bikes_available_mechanical,
        station_status.num_bikes_available_types.mechanical
      )
      |> Map.put(:num_bikes_available_ebike, station_status.num_bikes_available_types.ebike)
      |> Map.put(:reported_at, station_status.last_reported)

    {:ok, _} =
      %AveloDataInfrastructure.StationStatusSchema{}
      |> Ecto.Changeset.cast(
        station_params,
        [
          :station_id,
          :reported_at,
          :num_bikes_available,
          :num_bikes_available_mechanical,
          :num_bikes_available_ebike,
          :num_bikes_disabled,
          :num_docks_available,
          :num_docks_disabled,
          :is_charging_station,
          :status,
          :is_installed,
          :is_renting,
          :is_returning
        ],
        empty_values: []
      )
      |> AveloData.Repo.insert(
        on_conflict: :replace_all,
        conflict_target: [:station_id, :reported_at]
      )
  end
end
