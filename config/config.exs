# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :avelo_data, AveloDataWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AveloDataWeb.ErrorHTML, json: AveloDataWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AveloData.PubSub,
  live_view: [signing_salt: "OYjRL4NV"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  avelo_data: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.11",
  avelo_data: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, JSON

config :avelo_data, AveloData.Repo, migration_timestamps: [type: :timestamptz]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :tz, reject_periods_before_year: 2025

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
