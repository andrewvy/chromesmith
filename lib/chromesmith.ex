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
      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :supervisor
        }
      end

      def start_link(opts \\ []) do
        Chromesmith.Supervisor.start_link(__MODULE__, opts)
      end

      def config() do
        Chromesmith.Supervisor.runtime_config(__MODULE__, [])
      end
    end
  end
end
