defmodule Plug.CloudflareAccess do
  import CloudflareAccess, only: [get: 0]
  import Plug.Conn
  require Logger

  @alg "RS256"

  def init(opts) do
    opts
  end

  defp authenticate({conn, jwt}) do
    case Joken.verify(jwt, signer()) do
      {:ok, claims} -> assign(conn, :user, claims)
      {:error, err} -> send_401(conn, %{error: err})
    end
  end

  defp authenticate({conn}) do
    send_401(conn)
  end

  defp send_401(
         conn,
         data \\ %{message: "Please make sure you have authentication header"}
       ) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Poison.encode!(data))
    |> halt
  end

  defp get_auth_header(conn) do
    case get_req_header(conn, "cf-access-jwt-assertion") do
      [token] -> {conn, token}
      _ -> {conn}
    end
  end

  def call(%Plug.Conn{request_path: _path} = conn, _opts) do
    case CloudflareAccess.domain() do
      domain when is_binary(domain) and domain != "" ->
        conn
        |> get_auth_header
        |> authenticate

      _ ->
        Logger.info("Endpoint for retrieving CF access certificate not configured!")
        conn
    end
  end

  defp signer do
    cert = get()
    Joken.Signer.create(@alg, %{"pem" => cert})
  end
end
