defmodule AveloData.StationOccupancy do
  use TypedStruct

  typedstruct enforce: true do
    field :date, Date.t()
    field :data, Explorer.DataFrame.t()
  end
end
