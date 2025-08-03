defmodule AveloData.StationStatusFinder do
  alias AveloData.StationStore

  def find() do
    StationStore.retrieve()
  end
end
