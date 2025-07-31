# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :avelo_data,
  ecto_repos: [AveloData.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :avelo_data, AveloDataWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AveloDataWeb.ErrorHTML, json: AveloDataWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AveloData.PubSub,
  live_view: [signing_salt: "6U3nCm0C"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  avelo_data: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  avelo_data: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use JSON for JSON parsing in Phoenix
config :phoenix, :json_library, JSON

config :avelo_data, AveloData.Repo, migration_timestamps: [type: :timestamptz]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
