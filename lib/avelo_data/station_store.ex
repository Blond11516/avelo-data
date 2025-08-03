defmodule AveloData.StationStore do
  alias AveloData.Station
  alias AveloData.S3Client

  @stations_object_key "stations.json"

  def store(stations) when is_list(stations) do
    encoded_stations =
      stations
      |> Enum.map(fn %Station{} = station ->
        %{
          id: station.id,
          geolocation: %{
            lat: station.geolocation.coordinates |> elem(0),
            lon: station.geolocation.coordinates |> elem(1)
          },
          capacity: station.capacity,
          name: station.name
        }
      end)
      |> JSON.encode!()

    S3Client.put_object(%S3Client.S3Request{
      key: @stations_object_key,
      body: encoded_stations
    })
  end

  def retrieve() do
    with {:ok, response} <- S3Client.get_object(%S3Client.S3Request{key: @stations_object_key}),
         {:ok, stations} <- JSON.decode(response.body) do
      {:ok, Enum.map(stations, &parse_station/1)}
    end
  end

  defp parse_station(%{
         "id" => id,
         "geolocation" => %{"lat" => lat, "lon" => lon},
         "capacity" => capacity,
         "name" => name
       }) do
    %Station{
      id: id,
      geolocation: %Geo.Point{coordinates: {lat, lon}},
      capacity: capacity,
      name: name
    }
  end
end
