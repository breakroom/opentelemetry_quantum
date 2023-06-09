defmodule TestJobs do
  def success() do
    :ok
  end

  def exception() do
    raise ArgumentError
  end

  def exit() do
    exit(1)
  end
end
