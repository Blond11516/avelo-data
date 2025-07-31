defmodule AveloData.Models.StationStatus do
  use TypedStruct

  typedstruct enforce: true do
    field :station_id, String.t()
    field :num_bikes_available, non_neg_integer()
    field :num_bikes_available_types, %{mechanical: non_neg_integer(), ebike: non_neg_integer()}
    field :num_bikes_disabled, non_neg_integer()
    field :num_docks_available, non_neg_integer()
    field :num_docks_disabled, non_neg_integer()
    field :last_reported, DateTime.t()
    field :is_charging_station, boolean()
    field :status, String.t()
    field :is_installed, boolean()
    field :is_renting, boolean()
    field :is_returning, boolean()
    field :traffic, nil
  end
end
