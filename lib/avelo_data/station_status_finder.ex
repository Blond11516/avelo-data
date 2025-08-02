defmodule AveloData.StationStatusFinder do
  alias AveloData.Repo
  alias AveloDataInfrastructure.StationSchema

  def find() do
    Repo.all(StationSchema)
  end
end
