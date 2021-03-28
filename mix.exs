defmodule ConstructParams.MixProject do
  use Mix.Project

  @github_url "https://github.com/Nitrino/construct_params"

  def project do
    [
      app: :construct_params,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "ConstructParams",
      source_url: @github_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: :construct_params,
      maintainers: ["Petr Stepchenko"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@github_url}/blob/master/CHANGELOG.md",
        "GitHub" => @github_url
      }
    ]
  end

  defp description do
    "Casting the incoming controller parameters"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:construct, "~> 2.1"},
      {:decorator, "~> 1.4"},
      {:ex_doc, "~> 0.24.1", only: :dev}
    ]
  end
end
