defmodule AveloData.Station do
  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
    field :capacity, integer()
    field :geolocation, Geo.Point.t()
  end
end
