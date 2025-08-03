defmodule AveloData.Gbfs.Client do
  alias AveloData.Gbfs.Models

  @base_url "https://quebec.publicbikesystem.net/customer/ube/gbfs/v1/en"

  def retrieve_station_information do
    with {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get("#{@base_url}/station_information") do
      {:ok, Enum.map(body["data"]["stations"], &parse_station/1)}
    end
  end

  defp parse_station(station_data) do
    %Models.Station{
      ride_code_support: Map.fetch!(station_data, "_ride_code_support"),
      address: Map.get(station_data, "address"),
      capacity: Map.fetch!(station_data, "capacity"),
      groups: Map.fetch!(station_data, "groups"),
      is_charging_station: Map.fetch!(station_data, "is_charging_station"),
      altitude: Map.fetch!(station_data, "altitude"),
      geolocation: %Geo.Point{
        coordinates: {Map.fetch!(station_data, "lat"), Map.fetch!(station_data, "lon")}
      },
      name: Map.fetch!(station_data, "name"),
      nearby_distance: Map.fetch!(station_data, "nearby_distance"),
      obcn: Map.fetch!(station_data, "obcn"),
      physical_configuration: Map.fetch!(station_data, "physical_configuration"),
      post_code: Map.get(station_data, "post_code"),
      rental_methods: Map.fetch!(station_data, "rental_methods"),
      rental_uris: Map.fetch!(station_data, "rental_uris"),
      short_name: Map.fetch!(station_data, "short_name"),
      station_id: Map.fetch!(station_data, "station_id")
    }
  end

  def retrieve_station_status do
    with {:ok, %Req.Response{status: 200, body: body}} <- Req.get("#{@base_url}/station_status") do
      {:ok, Enum.map(body["data"]["stations"], &parse_station_status/1)}
    end
  end

  defp parse_station_status(station_data) do
    %Models.StationStatus{
      station_id: Map.fetch!(station_data, "station_id"),
      num_bikes_available: Map.fetch!(station_data, "num_bikes_available"),
      num_bikes_available_types: %{
        mechanical: station_data["num_bikes_available_types"]["mechanical"],
        ebike: station_data["num_bikes_available_types"]["ebike"]
      },
      num_bikes_disabled: Map.fetch!(station_data, "num_bikes_disabled"),
      num_docks_available: Map.fetch!(station_data, "num_docks_available"),
      num_docks_disabled: Map.fetch!(station_data, "num_docks_disabled"),
      last_reported:
        Map.fetch!(station_data, "last_reported")
        |> DateTime.from_unix!(:second)
        |> DateTime.to_naive(),
      is_charging_station: Map.fetch!(station_data, "is_charging_station"),
      status: Map.fetch!(station_data, "status"),
      is_installed: Map.fetch!(station_data, "is_installed") |> integer_to_boolean(),
      is_renting: Map.fetch!(station_data, "is_renting") |> integer_to_boolean(),
      is_returning: Map.fetch!(station_data, "is_returning") |> integer_to_boolean(),
      traffic: Map.fetch!(station_data, "traffic")
    }
  end

  defp integer_to_boolean(0), do: false
  defp integer_to_boolean(int) when is_integer(int), do: true
end
