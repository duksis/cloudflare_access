use Mix.Config

if Mix.env() == :test do
  config :cloudflare_access, :domain, "duksis.lv"
end
