defmodule AveloDataConfig do
  def object_storage, do: Application.fetch_env!(:avelo_data, :object_storage)

  def update_interval, do: Application.fetch_env!(:avelo_data, :update_interval)
end
