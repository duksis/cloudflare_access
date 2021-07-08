defmodule CloudflareAccess do
  @moduledoc """
  Validating 'CloudflareAaccess' headers for incomming requests

  https://www.cloudflare.com/teams/access/
  """

  @table_name :cf_certificate_registry

  require Logger

  @doc """
  Retrieves cloudflare certificate for given domain.

  ## Examples

      iex> CloudflareAccess.get("duksis.lv")
      :ok

  """
  def get(domain \\ domain()) do
    try do
      case domain do
        domain when is_binary(domain) and domain != "" ->
          [{^domain, pid}] = :ets.lookup(@table_name, domain)
          Agent.get(pid, fn cert -> cert end)

        _ ->
          Logger.info("Endpoint for retrieving CF access certificate not configured!")
      end
    rescue
      MatchError ->
        cert = fetch(domain)
        {:ok, pid} = Agent.start_link(fn -> cert end)
        :ets.insert(@table_name, {domain, pid})
        cert
    end
  end

  @doc """
  Retrieves and persists the Cloudflare certificate for an given domain
  within an ETS table.

  ## Examples

      iex> CloudflareAccess.cache("duksis.lv")
      :ok

  """
  def cache(domain \\ domain()) do
    case domain do
      domain when is_binary(domain) and domain != "" ->
        :ets.new(@table_name, [:named_table])
        cert = fetch(domain)
        {:ok, pid} = Agent.start_link(fn -> cert end)
        :ets.insert(@table_name, {domain, pid})

      _ ->
        Logger.info("Endpoint for retrieving CF access certificate not configured!")
    end
  end

  @doc """
  Retrurns currently configured domain name for Cloudflare Access

  ## Examples

      iex> CloudflareAccess.domain()
      "duksis.lv"

  """
  def domain, do: Application.get_env(:cloudflare_access, :domain)

  defp fetch(domain) do
    %{status_code: 200, body: body} = HTTPoison.get!("https://#{domain}/cdn-cgi/access/certs")
    certificates = Poison.decode!(body)
    certificates |> Map.get("public_cert") |> Map.get("cert")
  end

end
