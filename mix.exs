defmodule CloudflareAccess.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloudflare_access,
      version: "0.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
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
      {:ex_doc, "~> 0.18", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      # JSON parsing
      {:poison, "~> 4.0"},
      # handling jwt tokens
      {:joken, "~> 2.0"},
      # http requests for retrieving CF access certificates
      {:httpoison, "~> 1.7"}
    ]
  end

  defp description do
    """
    Library for validating Cloudflare Access on application side.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Hugo Duksis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/duksis/cloudflare_access"}
    ]
  end
end
