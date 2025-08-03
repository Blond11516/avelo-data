defmodule AveloData.Gbfs.Models.Station do
  use TypedStruct

  typedstruct enforce: true do
    field :station_id, String.t()
    field :ride_code_support, boolean()
    field :address, String.t() | nil
    field :capacity, integer()
    field :groups, list(String.t())
    field :is_charging_station, boolean()
    field :altitude, float() | nil
    field :name, String.t()
    field :nearby_distance, float()
    field :obcn, String.t()
    field :physical_configuration, String.t()
    field :post_code, String.t() | nil
    field :rental_methods, list(String.t())
    field :rental_uris, map()
    field :short_name, String.t()

    field :geolocation, %{
      latitude: float(),
      longitude: float()
    }
  end

  def to_station(%__MODULE__{} = station) do
    %AveloData.Station{
      id: station.station_id,
      geolocation: station.geolocation,
      capacity: station.capacity,
      name: station.name
    }
  end
end
