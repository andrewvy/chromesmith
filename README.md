# chromesmith

:construction: [WIP]

Higher-level library for forging distributing workloads across an army of headless chrome workers.

Provides a higher-level DSL on top of [chrome-remote-interface](https://github.com/andrewvy/chrome-remote-interface),
and manages headless chrome processes with [chrome-launcher](https://github.com/andrewvy/chrome-launcher).

---

> Usage

*chromesmith* handles pooling page sessions and distributing work across them. You can configure this pool or use
the default configuration. It's highly recommended you tune your configuration to your runtime environment to
make best use of your resources.

> Add Chromesmith to your application supervision tree.

```
defmodule MyApp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Chromesmith.child_spec(:chrome_pool, [process_pool_size: 2])
    ]

    opts = [strategy: :one_for_one, name: ChromesmithExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```
