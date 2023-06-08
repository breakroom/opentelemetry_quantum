defmodule OpentelemetryQuantum.MixProject do
  use Mix.Project

  def project do
    [
      app: :opentelemetry_quantum,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      docs: [
        source_url_pattern:
          "https://github.com/breakroom/opentelemetry_quantum/blob/main/%{path}#L%{line}",
        main: "OpentelemetryQuantum",
        extras: ["README.md"]
      ],
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: [
        name: "opentelemetry_quantum",
        description: "OpenTelemetry tracing for Quantum",
        maintainers: ["Tom Taylor"],
        licenses: ["Apache-2.0"],
        files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
        source_url: "https://github.com/breakroom/opentelemetry_quantum"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:quantum, "~> 3.3"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_telemetry, "~> 1.0"},
      {:opentelemetry_semantic_conventions, "~> 0.2"},
      {:telemetry, "~> 0.4 or ~> 1.0"},
      {:opentelemetry, "~> 1.0", only: [:test]},
      {:opentelemetry_exporter, "~> 1.0", only: [:test]},
      {:ex_doc, "~> 0.29", only: [:dev], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
