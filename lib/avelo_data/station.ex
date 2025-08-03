defmodule AveloData.Station do
  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
    field :capacity, integer()

    field :geolocation, %{
      latitude: float(),
      longitude: float()
    }
  end

  def from_gbfs_station(%AveloData.Gbfs.Models.Station{} = station) do
    %__MODULE__{
      id: station.station_id,
      geolocation: station.geolocation,
      capacity: station.capacity,
      name: station.name
    }
  end
end
