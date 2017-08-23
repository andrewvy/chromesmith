defmodule Chromesmith do
  @moduledoc false
  use Supervisor

  @default_opts [
    process_pool_size: 4,
    number_of_pages_per_process: 16
  ]

  def child_spec(name, opts, start_opts \\ [])
  def child_spec(name, opts, start_opts) do
    %{
      id: name,
      start: {__MODULE__, :start_link, [opts, start_opts]},
      type: :supervisor
    }
  end

  def start_link(opts, start_opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, start_opts)
  end

  def init(opts) do
    merged_opts =
      @default_opts
      |> Keyword.merge(opts)

    children =
      Enum.map(1..merged_opts[:process_pool_size], fn(index) ->
        Supervisor.child_spec({Chromesmith.Worker, {index, merged_opts}}, id: :"chromesmith_worker_#{index}")
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
