defmodule Chromesmith.Worker do
  use GenServer

  alias ChromeRemoteInterface.{Session, PageSession}

  def start_link(index, chrome_options) do
    GenServer.start_link(__MODULE__, {index, chrome_options})
  end

  def init({index, chrome_options}) do
    default_opts = ChromeLauncher.default_opts()
    default_flags =
      default_opts
      |> Keyword.get(:flags)
      |> MapSet.new()

    flags =
      chrome_options
      |> MapSet.new()

    merged_flags =
      MapSet.union(default_flags, flags)
      |> MapSet.to_list()

    opts = [
      remote_debugging_port: 9222 + index,
      flags: merged_flags
    ]

    {:ok, pid} = ChromeLauncher.launch(opts)

    {:ok, %{pid: pid, page_sessions: [], opts: opts}}
  end

  def start_pages(pid, opts) do
    GenServer.call(pid, {:start_pages, opts})
  end

  def handle_call({:start_pages, opts}, _from, state) do
    session = Session.new([
      port: state.opts[:remote_debugging_port]
    ])

    # Headless Chrome will start with an initial page, so we will
    # need to retrieve it in order to connect to it.
    {:ok, [initial_page]} = Session.list_pages(session)
    {:ok, initial_page_session} = PageSession.start_link(initial_page)
    page_sessions = spawn_pages(session, opts[:page_pool_size])
    all_page_sessions = [initial_page_session | page_sessions]

    {:reply, all_page_sessions, %{state | page_sessions: all_page_sessions}}
  end

  def spawn_pages(session, number_of_pages)
  def spawn_pages(_session, 1), do: []
  def spawn_pages(session, number_of_pages) do
    Enum.map(1..number_of_pages - 1, fn(_) ->
      {:ok, page} = Session.new_page(session)
      {:ok, page_session} = PageSession.start_link(page)
      page_session
    end)
  end
end
