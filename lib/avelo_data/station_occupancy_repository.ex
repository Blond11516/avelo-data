defmodule AveloData.StationOccupancyRepository do
  alias AveloData.S3Client
  alias AveloData.StationOccupancy
  alias Explorer.DataFrame

  def store(%StationOccupancy{} = station_occupancy) do
    # TODO get existing data and merge
    # TODO benchmark parquet compression
    with {:ok, parquet} <- DataFrame.dump_parquet(station_occupancy.data),
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
           }),
         {:ok, df} <- DataFrame.load_parquet(response.body) do
      {:ok, %StationOccupancy{date: date, data: df}}
    end
  end
end
