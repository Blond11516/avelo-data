defmodule AveloData.Repo do
  use Ecto.Repo,
    otp_app: :avelo_data,
    adapter: Ecto.Adapters.Postgres
end
