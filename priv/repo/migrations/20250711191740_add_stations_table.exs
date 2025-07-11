defmodule AveloData.Repo.Migrations.AddStationsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION postgis", "DROP EXTENSION postgis"

    create table("station") do
      add :ride_code_support, :bool, null: false
      add :address, :text, null: true
      add :capacity, :smallint, null: false
      add :groups, {:array, :text}, null: false
      add :is_charging_station, :bool, null: false
      add :altitude, :"double precision", null: true
      add :geolocation, :geometry, null: false
      add :name, :text, null: false
      add :nearby_distance, :"double precision", null: false
      add :obcn, :text, null: false
      add :physical_configuration, :text, null: false
      add :post_code, :text, null: true
      add :rental_methods, {:array, :text}, null: false
      add :rental_uris, :jsonb, null: false
      add :short_name, :text, null: false
      add :station_id, :text, null: false

      timestamps()
    end

    create index("station", [:station_id], unique: true)
  end
end
