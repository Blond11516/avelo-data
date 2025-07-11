defmodule AveloDataInfrastructure.StationSchema do
  use Ecto.Schema

  @timestamps_opts type: :utc_datetime

  schema "station" do
    field :ride_code_support, :boolean
    field :address, :string
    field :capacity, :integer
    field :groups, {:array, :string}
    field :is_charging_station, :boolean
    field :altitude, :float
    field :geolocation, Geo.PostGIS.Geometry
    field :name, :string
    field :nearby_distance, :float
    field :obcn, :string
    field :physical_configuration, :string
    field :post_code, :string
    field :rental_methods, {:array, :string}
    field :rental_uris, :map
    field :short_name, :string
    field :station_id, :string, primary_key: true

    timestamps()
  end
end
