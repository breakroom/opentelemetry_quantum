defmodule OpentelemetryQuantum do
  @moduledoc """
  Documentation for `OpentelemetryQuantum`.
  """

  alias OpentelemetryQuantum.JobHandler

  def setup(_config) do
    :ok = JobHandler.attach()
  end
end
