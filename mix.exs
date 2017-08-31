defmodule Chromesmith.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chromesmith,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "Chromesmith",
      source_url: "https://github.com/andrewvy/chromesmith",
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:chrome_launcher, "~> 0.0.1"},
      {:chrome_remote_interface, "~> 0.0.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "Higher-level library for forging distributing workloads across an army of managed headless chrome workers."
  end

  defp package do
    [
      maintainers: ["andrew@andrewvy.com"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/andrewvy/chromesmith"
      }
    ]
  end
end
