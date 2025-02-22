defmodule IndonesianId.MixProject do
  use Mix.Project

  def project do
    [
      app: :indonesian_id,
      version: "1.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "indonesian_id",
      source_url: "https://github.com/muzhawir/indonesian_id",
      homepage_url: "https://hex.pm/packages/indonesian_id",
      docs: &docs/0
    ]
  end

  defp description do
    "Package for parsing and looking-up various Indonesian ID numbers or codes."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/muzhawir/indonesian_id"}
    ]
  end

  defp docs do
    [
      main: "readme",
      logo: "./priv/docs/logo.svg",
      extras: ["README.md"]
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
      {:styler, "~> 1.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
