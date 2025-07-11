defmodule AveloData.Station do
  @enforce_keys [
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
  ]
  defstruct [
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
  ]

  @type t :: %__MODULE__{
          ride_code_support: boolean(),
          address: String.t() | nil,
          capacity: integer(),
          groups: list(String.t()),
          is_charging_station: boolean(),
          altitude: float() | nil,
          geolocation: Geo.Point.t(),
          name: String.t(),
          nearby_distance: float(),
          obcn: String.t(),
          physical_configuration: String.t(),
          post_code: String.t() | nil,
          rental_methods: list(String.t()),
          rental_uris: map(),
          short_name: String.t(),
          station_id: String.t()
        }
end
