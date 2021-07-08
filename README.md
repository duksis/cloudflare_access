# CloudflareAccess

Plug for verifying Cloudflare Access headers inside your application.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudflare_access` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudflare_access, "~> 0.1.0"}
  ]
end
```

## Usage

```
defmodule YourAppRouter do
  use Plug.Router

  plug(Plug.CloudflareAccess)

  ...

end

```

```
# in your config/config.exs

config :cloudflare_access, domain: "exapmle.com"
```


For loading Cloudflare public key for your domain on application boot

```
defmodel YourApplication do
  use Application
  ...
  def start(_type, _args) do
    ...
    # Retrieve CF access certificate from CF and save in ETS
    CloudflareAccess.cache()
    ...
  end
  ...
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cloudflare_access](https://hexdocs.pm/cloudflare_access).

