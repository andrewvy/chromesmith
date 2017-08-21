defmodule Chromesmith.Worker do
  use GenServer

  def start_link({index, opts}) do
    GenServer.start_link(__MODULE__, {index, opts})
  end

  def init({index, _opts}) do
    ChromeLauncher.launch([
      remote_debugging_port: 9222 + index
    ])
  end
end
