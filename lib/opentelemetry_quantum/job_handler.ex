defmodule OpentelemetryQuantum.JobHandler do
  alias OpenTelemetry.Span
  alias OpenTelemetry.SemanticConventions.Trace

  require Trace

  @tracer_id __MODULE__

  def attach() do
    :ok =
      :telemetry.attach(
        "#{__MODULE__}.job_start",
        [:quantum, :job, :start],
        &__MODULE__.handle_job_start/4,
        []
      )

    :ok =
      :telemetry.attach(
        "#{__MODULE__}.job_stop",
        [:quantum, :job, :stop],
        &__MODULE__.handle_job_stop/4,
        []
      )

    :ok =
      :telemetry.attach(
        "#{__MODULE__}.job_exception",
        [:quantum, :job, :exception],
        &__MODULE__.handle_job_exception/4,
        []
      )

    :ok
  end

  def handle_job_start(
        _event,
        _measurements,
        %{job: %Quantum.Job{} = job, node: node, scheduler: scheduler} = metadata,
        _config
      ) do
    attributes = %{
      "cronjob.system": :quantum,
      "cronjob.quantum.node": inspect(node),
      "cronjob.quantum.scheduler": inspect(scheduler),
      "cronjob.quantum.job_name": job.name,
      "cronjob.quantum.job_schedule": Crontab.CronExpression.Composer.compose(job.schedule),
      "cronjob.quantum.job_overlap": job.overlap,
      "cronjob.quantum.job_timezone": job.timezone
    }

    OpentelemetryTelemetry.start_telemetry_span(@tracer_id, span_name(job), metadata, %{
      kind: :consumer,
      attributes: attributes
    })
  end

  def handle_job_stop(_event, _measurements, metadata, _config) do
    OpentelemetryTelemetry.end_telemetry_span(@tracer_id, metadata)
  end

  def handle_job_exception(
        _event,
        _measurements,
        %{stacktrace: stacktrace, kind: :error, reason: reason} = metadata,
        _config
      ) do
    ctx = OpentelemetryTelemetry.set_current_telemetry_span(@tracer_id, metadata)

    # Record exception and mark the span as errored
    Span.record_exception(ctx, reason, stacktrace)
    Span.set_status(ctx, OpenTelemetry.status(:error, format_error(reason)))

    OpentelemetryTelemetry.end_telemetry_span(@tracer_id, metadata)
  end

  defp format_error(exception) when is_exception(exception), do: Exception.message(exception)
  defp format_error(error), do: inspect(error)

  defp span_name(%Quantum.Job{name: name}) when is_atom(name) do
    to_string(name) <> " job"
  end

  defp span_name(_) do
    "anonymous job"
  end
end
