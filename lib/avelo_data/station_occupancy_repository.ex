defmodule AveloData.StationOccupancyRepository do
  alias AveloData.S3Client
  alias AveloData.StationOccupancy
  alias Explorer.DataFrame

  def store(%StationOccupancy{} = station_occupancy) do
    # TODO benchmark parquet compression
    default_occupancy = StationOccupancy.empty_on(station_occupancy.date)

    with {:ok, existing_occupancy} <- retrieve(station_occupancy.date),
         station_occupancy =
           StationOccupancy.merge_with(existing_occupancy || default_occupancy, station_occupancy),
         {:ok, parquet} <- DataFrame.dump_parquet(station_occupancy.data),
         :ok <-
           S3Client.put_object(%S3Client.S3Request{
             key: "station-data_#{Date.to_iso8601(station_occupancy.date)}.parquet",
             body: parquet
           }) do
      :ok
    end
  end

  def retrieve(%Date{} = date) do
    with {:ok, response} <-
           S3Client.get_object(%S3Client.S3Request{
             key: "station-data_#{Date.to_iso8601(date)}.parquet"
           }) do
      case response do
        %{status: 404} ->
          {:ok, nil}

        %{status: 200} ->
          {:ok, %StationOccupancy{date: date, data: DataFrame.load_parquet!(response.body)}}
      end
    end
  end
end
