defmodule Chromesmith do
  @moduledoc """
  Main module for Chromesmith.
  """
  use GenServer

  defstruct [
    supervisor: nil, # Chromesmith.Supervisor PID
    process_pool_size: 0, # How many Headless Chrome instances to spawn
    number_of_pages_per_process: 0, # How many Pages per Instance
    workers: [], # List of worker tuples, {pid, number_of_used_pages, number_of_total_pages}
    chrome_options: [] # Options to pass into `:chrome_launcher`
  ]

  @type t :: %__MODULE__{
    supervisor: pid(),
    process_pool_size: non_neg_integer(),
    number_of_pages_per_process: non_neg_integer(),
    workers: [{pid(), non_neg_integer(), non_neg_integer()}]
  }

  @doc """
  Check out a Page from one of the headless chrome processes.
  """
  def checkout(pid, should_block \\ true)
  def checkout(pid, should_block) do
    GenServer.call(pid, {:checkout, should_block})
  end

  @doc """
  Check in a Page that has completed work.
  """
  def checkin(pid, worker) do
    GenServer.cast(pid, {:checkin, worker})
  end

  # ---
  # Private
  # ---

  def child_spec(name, opts, start_opts \\ [])
  def child_spec(name, opts, start_opts) do
    %{
      id: name,
      start: {__MODULE__, :start_link, [opts, start_opts]},
      type: :worker
    }
  end

  def start_link(opts, start_opts \\ []) do
    GenServer.start_link(__MODULE__, opts, start_opts)
  end

  def init(opts) when is_list(opts) do
    {:ok, supervisor_pid} = Chromesmith.Supervisor.start_link(opts)

    state = %Chromesmith{
      supervisor: supervisor_pid,
      process_pool_size: Keyword.get(opts, :process_pool_size, 4),
      number_of_pages_per_process: Keyword.get(opts, :number_of_pages_per_process, 16),
      chrome_options: Keyword.get(opts, :chrome_options, [])
    }

    init(state)
  end

  def init(%Chromesmith{} = state) do
    workers = prepopulate_pool(state.supervisor, state)
    {:ok, %{state | workers: workers}}
  end

  def prepopulate_pool(supervisor, state) do
    children =
      Enum.map(1..state.process_pool_size, fn(index) ->
        start_worker(supervisor, index, state)
      end)

    children
  end

  def start_worker(supervisor, index, state) do
    {:ok, child} = Supervisor.start_child(
      supervisor,
      %{
        id: index,
        start: {Chromesmith.Worker, :start_link, [{index, state.chrome_options}]},
        restart: :temporary,
        shutdown: 5000,
        type: :worker
      }
    )

    {child, 0, state.number_of_pages_per_process}
  end
end
