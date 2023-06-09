ExUnit.start()

defmodule TestScheduler do
  use Quantum, otp_app: :opentelemetry_quantum
end

{:ok, _} =
  TestScheduler.start_link(
    jobs: [
      success: [schedule: "@weekly", task: {TestJobs, :success, []}],
      exception: [schedule: "@weekly", task: {TestJobs, :exception, []}],
      exit: [schedule: "@weekly", task: {TestJobs, :exit, []}]
    ]
  )
