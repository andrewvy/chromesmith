defmodule Chromesmith.Supervisor do
  use Supervisor

  @default_config [
    process_pool_size: 4,
    number_of_pages_per_process: 16
  ]

  def start_link(module) do
    Supervisor.start_link(__MODULE__, module)
  end

  def runtime_config(module, config) do
    config =
      @default_config
      |> Keyword.merge(config)

    case _init(module, config) do
      {:ok, config} -> config
      _ -> config
    end
  end

  def init(module) do
    opts = runtime_config(module, [])

    children =
      Enum.map(1..opts[:process_pool_size], fn(index) ->
        Supervisor.child_spec({Chromesmith.Worker, {index, opts}}, id: :"chromesmith_worker_#{index}")
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp _init(module, config) do
    if Code.ensure_loaded?(module) and function_exported?(module, :init, 1) do
      module.init(config)
    else
      {:ok, config}
    end
  end
end
