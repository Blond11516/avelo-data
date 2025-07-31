defmodule AveloData.StationInformationUpdater do
  require Logger

  def update() do
    {:ok, stations} = AveloData.GbfsClient.retrieve_station_informations()
    Enum.each(stations, &upsert_station/1)
    :ok
  end

  defp upsert_station(station) do
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
end
