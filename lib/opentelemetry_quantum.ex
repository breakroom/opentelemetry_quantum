defmodule OpentelemetryQuantum do
  @moduledoc """
  OpentelemetryQuantum uses [telemetry](https://hexdocs.pm/telemetry/) handlers
  to create `OpenTelemetry` spans from [Quantum](https://hexdocs.pm/quantum/)
  jobs.

  It supports job start, stop and exception events.

  ## Usage

  In your application start:

  ```
  def start(_type, _args) do
    :ok = OpentelemetryQuantum.setup()

    # ...
  end
  """

  alias OpentelemetryQuantum.JobHandler

  @doc """
  Attaches the telemetry handlers, returning `:ok` if successful.
  """
  @spec setup :: :ok
  def setup() do
    :ok = JobHandler.attach()
  end
end
