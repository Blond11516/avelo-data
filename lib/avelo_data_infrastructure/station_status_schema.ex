defmodule AveloDataInfrastructure.StationStatusSchema do
  use Ecto.Schema

  schema "station_status" do
    field :station_id, :string, primary_key: true
    field :reported_at, :utc_datetime, primary_key: true
    field :num_bikes_available, :integer
    field :num_bikes_available_mechanical, :integer
    field :num_bikes_available_ebike, :integer
    field :num_bikes_disabled, :integer
    field :num_docks_available, :integer
    field :num_docks_disabled, :integer
    field :is_charging_station, :boolean
    field :status, :string
    field :is_installed, :boolean
    field :is_renting, :boolean
    field :is_returning, :boolean
  end
end
