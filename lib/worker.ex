defmodule Chromesmith.Worker do
  use GenServer

  alias ChromeRemoteInterface.{Session, PageSession}

  def start_link({index, chrome_opts}) do
    GenServer.start_link(__MODULE__, {index, chrome_opts})
  end

  def init({index, _opts}) do
    opts = [
      remote_debugging_port: 9222 + index
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

    page_sessions =
      Enum.map(1..opts[:page_pool_size] - 1, fn(_) ->
        {:ok, page} = Session.new_page(session)
        {:ok, page_session} = PageSession.start_link(page)
        page_session
      end)

    {:reply, page_sessions, %{state | page_sessions: page_sessions}}
  end
end
