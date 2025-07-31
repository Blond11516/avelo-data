defmodule AveloData.GbfsClient do
  @base_url "https://quebec.publicbikesystem.net/customer/ube/gbfs/v1/en"

  def retrieve_station_informations do
    {:ok, %Req.Response{status: 200, body: body}} = Req.get("#{@base_url}/station_information")
    {:ok, Enum.map(body["data"]["stations"], &parse_station/1)}
  end

  defp parse_station(station_data) do
    %AveloData.Station{
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
end
