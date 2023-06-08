defmodule OpentelemetryQuantumTest do
  use ExUnit.Case
  doctest OpentelemetryQuantum

  require OpenTelemetry.Tracer
  require OpenTelemetry.Span
  require Record

  for {name, spec} <- Record.extract_all(from_lib: "opentelemetry/include/otel_span.hrl") do
    Record.defrecord(name, spec)
  end

  for {name, spec} <- Record.extract_all(from_lib: "opentelemetry_api/include/opentelemetry.hrl") do
    Record.defrecord(name, spec)
  end

  setup do
    :application.stop(:opentelemetry)
    :application.set_env(:opentelemetry, :tracer, :otel_tracer_default)

    :application.set_env(:opentelemetry, :processors, [
      {:otel_batch_processor, %{scheduled_delay_ms: 1, exporter: {:otel_exporter_pid, self()}}}
    ])

    :application.start(:opentelemetry)

    TestHelpers.remove_handlers()
    OpentelemetryQuantum.setup([])

    :ok
  end

  test "records span on succesful job execution" do
    TestScheduler.run_job(:success)

    assert_receive {:span,
                    span(
                      name: "success job",
                      attributes: attributes,
                      parent_span_id: :undefined,
                      kind: :consumer,
                      status: :undefined
                    )}

    assert :otel_attributes.map(attributes) == %{
             "cronjob.system": :quantum,
             "cronjob.quantum.node": ":nonode@nohost",
             "cronjob.quantum.scheduler": "TestScheduler",
             "cronjob.quantum.job_name": :success,
             "cronjob.quantum.job_schedule": "0 0 * * 0 *",
             "cronjob.quantum.job_overlap": true,
             "cronjob.quantum.job_timezone": :utc
           }
  end

  test "records span on job raising exception" do
    TestScheduler.run_job(:exception)

    expected_status = OpenTelemetry.status(:error, "argument error")

    assert_receive {:span,
                    span(
                      name: "exception job",
                      attributes: attributes,
                      parent_span_id: :undefined,
                      kind: :consumer,
                      status: ^expected_status
                    )}
  end
end
