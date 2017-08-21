defmodule Chromesmith do
  @moduledoc """
  This module is used for defining a Chromesmith module.

  You can provide runtime configuration using an `init/1` callback.

  This function will be called, passing in default options for you to
  override. You must return `{:ok, config}`.

  Example:

      defmodule Chromesmith.Test do
        use Chromesmith

        def init(opts) do
          {:ok, Keyword.merge(opts, [process_pool_size: 5])}
        end
      end

  """
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import Supervisor

      def start_link() do
        Chromesmith.Supervisor.start_link(__MODULE__)
      end

      def config() do
        Chromesmith.Supervisor.runtime_config(__MODULE__, [])
      end
    end
  end
end
