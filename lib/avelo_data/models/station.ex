defmodule AveloData.Models.Station do
  use TypedStruct

  typedstruct enforce: true do
    field :ride_code_support, boolean()
    field :address, String.t() | nil
    field :capacity, integer()
    field :groups, list(String.t())
    field :is_charging_station, boolean()
    field :altitude, float() | nil
    field :geolocation, Geo.Point.t()
    field :name, String.t()
    field :nearby_distance, float()
    field :obcn, String.t()
    field :physical_configuration, String.t()
    field :post_code, String.t() | nil
    field :rental_methods, list(String.t())
    field :rental_uris, map()
    field :short_name, String.t()
    field :station_id, String.t()
  end
end
