defmodule Chromesmith.Supervisor do
  @moduledoc """
  This module implements the Supervisor that
  supervises all of the chrome headless processes.
  """

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    Supervisor.init([], strategy: :one_for_one)
  end
end
