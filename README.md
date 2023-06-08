# OpentelemetryQuantum

OpentelemetryQuantum uses [telemetry](https://hexdocs.pm/telemetry/) handlers to
create `OpenTelemetry` spans from [Quantum](https://hexdocs.pm/quantum/) jobs.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `opentelemetry_quantum` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentelemetry_quantum, "~> 0.1"}
  ]
end
```

In your application start:

```elixir
def start(_type, _args) do
  OpentelemetryQuantum.setup()

  # ...
end
```

## Usage

A new trace is automatically started when a Quantum job executes.
