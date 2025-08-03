defmodule AveloData.StationOccupancy do
  use TypedStruct

  alias Explorer.DataFrame

  typedstruct enforce: true do
    field :date, Date.t()
    field :data, Explorer.DataFrame.t()
  end

  def empty_on(%Date{} = date) do
    %__MODULE__{
      date: date,
      data:
        DataFrame.new(
          reported_at: [],
          station_id: [],
          num_bikes_available: [],
          num_docks_available: []
        )
    }
  end

  def from_gbfs_status(station_statuses) when is_list(station_statuses) do
    date =
      station_statuses
      |> Enum.map(fn status -> NaiveDateTime.to_date(status.last_reported) end)
      |> Enum.max(&Date.after?/2)

    df =
      DataFrame.new([])
      |> DataFrame.put(:reported_at, Enum.map(station_statuses, & &1.last_reported),
        dtype: {:naive_datetime, :millisecond}
      )
      |> DataFrame.put(:station_id, Enum.map(station_statuses, & &1.station_id))
      |> DataFrame.put(
        :num_bikes_available,
        Enum.map(station_statuses, & &1.num_bikes_available),
        dtype: {:u, 16}
      )
      |> DataFrame.put(
        :num_docks_available,
        Enum.map(station_statuses, & &1.num_docks_available),
        dtype: {:u, 16}
      )

    %__MODULE__{
      date: date,
      data: df
    }
  end

  def merge_with(
        %__MODULE__{date: date} = existing_occupancy,
        %__MODULE__{date: date} = new_occupancy
      ) do
    df =
      DataFrame.concat_rows([new_occupancy.data, existing_occupancy.data])
      |> DataFrame.distinct([:reported_at, :station_id], keep_all: true)

    %__MODULE__{date: date, data: df}
  end
end
