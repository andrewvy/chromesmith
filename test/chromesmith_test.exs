defmodule ChromesmithTest do
  use ExUnit.Case, async: false

  doctest Chromesmith

  setup_all do
    {:ok, pid} = Chromesmith.start_link([process_pool_size: 1, page_pool_size: 1])
    [pool_pid: pid]
  end

  test "Can checkout page", context do
    {:ok, page_pid} = Chromesmith.checkout(context[:pool_pid])
    assert :ok == Chromesmith.checkin(context[:pool_pid], page_pid)
  end

  test "Checking out more than enough pages will return a :none_available message", context do
    {:ok, pid} = Chromesmith.checkout(context[:pool_pid])

    assert {:error, :none_available} == Chromesmith.checkout(context[:pool_pid], false)
    assert :ok == Chromesmith.checkin(context[:pool_pid], pid)
  end
end
