defmodule AveloData.MixProject do
  use Mix.Project

  def project do
    [
      app: :avelo_data,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AveloData.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bandit, "1.7.0"},
      {:dns_cluster, "0.2.0"},
      {:explorer, "0.11.0"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:phoenix, "1.8.0-rc.4", override: true},
      {:phoenix_html, "4.2.1"},
      {:phoenix_live_dashboard, "0.8.7"},
      {:phoenix_live_view, "1.1.2"},
      {:req, "0.5.15"},
      {:telemetry_metrics, "1.1.0"},
      {:telemetry_poller, "1.3.0"},
      {:typedstruct, "0.5.3"},

      # Dev/build dependencies
      {:esbuild, "0.10.0", runtime: Mix.env() == :dev},
      {:phoenix_live_reload, "1.6.0", only: :dev},
      {:tailwind, "0.3.1", runtime: Mix.env() == :dev},

      # Test dependencies
      {:lazy_html, "0.1.3", only: :test},

      # No-runtime dev dependencies
      {:igniter, "0.6.25", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      test: "test",
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind avelo_data", "esbuild avelo_data"],
      "assets.deploy": [
        "tailwind avelo_data --minify",
        "esbuild avelo_data --minify",
        "phx.digest"
      ]
    ]
  end
end
