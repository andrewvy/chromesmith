defmodule Chromesmith.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chromesmith,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:chrome_remote_interface, "~> 0.0.2"}
    ]
  end
end
