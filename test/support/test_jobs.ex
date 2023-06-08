defmodule TestJobs do
  def success() do
    :ok
  end

  def exception() do
    raise ArgumentError
  end
end
