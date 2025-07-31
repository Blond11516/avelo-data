defmodule AveloData.Repo.Migrations.AddStationStatusTable do
  use Ecto.Migration

  def change do
    create table("station_status") do
      add :station_id, references("station", column: :station_id, type: :text), null: false

      add :reported_at, :timestamptz, null: false
      add :num_bikes_available, :smallint, null: false
      add :num_bikes_available_mechanical, :smallint, null: false
      add :num_bikes_available_ebike, :smallint, null: false
      add :num_bikes_disabled, :smallint, null: false
      add :num_docks_available, :smallint, null: false
      add :num_docks_disabled, :smallint, null: false
      add :is_charging_station, :boolean, null: false
      add :status, :text, null: false
      add :is_installed, :boolean, null: false
      add :is_renting, :boolean, null: false
      add :is_returning, :boolean, null: false
    end

    create index("station_status", [:station_id, :reported_at], unique: true)
  end
end
