# chromesmith

:construction: [WIP]

Higher-level library for forging distributing workloads across an army of headless chrome workers.

Utilizes the Chrome Debugger Protocol with [chrome-remote-interface](https://github.com/andrewvy/chrome-remote-interface) to
manage headless chrome instances.

---

> Usage

*chromesmith* handles pooling page sessions and distributing work across them. You can configure this pool or use
the default configuration. It's highly recommended you tune your configuration to your runtime environment to
make best use of your resources.

> Create a new module for *chromesmith*:

```elixir
defmodule MyApp.Chromesmith do
  use Chromesmith
end
```

> Add that module to your application supervision tree.

```
# Add example here
```

> Provide runtime configuration using the `init/1` callback.

```elixir
defmodule MyApp.Chromesmith do
  use Chromesmith

  def init(config) do
    Keyword.merge(config, [
      pool_size: 50
    ])
  end
end
```
