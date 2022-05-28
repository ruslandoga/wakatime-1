defmodule W1.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug :dispatch

  post "/heartbeats", do: ingest(conn)
  post "/heartbeats/v1/users/current/heartbeats.bulk", do: ingest(conn)
  post "/users/current/heartbeats.bulk", do: ingest(conn)
  post "/plugins/errors", do: ignore(conn)
  match _, do: send_resp(conn, 404, "Not found")

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end

  defp ingest(conn) do
    %{"_json" => heartbeats} = conn.body_params

    :ok = W1.Ingester.insert_heartbeats(heartbeats)

    conn
    |> put_status(201)
    |> json(ingeset_response(heartbeats))
  end

  defp ingeset_response(heartbeats) do
    case heartbeats do
      heartbeats when is_list(heartbeats) ->
        %{"responses" => Enum.map(heartbeats, fn _ -> [nil, 201] end)}

      %{} = heartbeat ->
        %{"data" => heartbeat}
    end
  end

  @spec json(Plug.Conn.t(), term) :: Plug.Conn.t()
  defp json(conn, data) do
    response = Jason.encode_to_iodata!(data)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status || 200, response)
  end

  defp ignore(conn) do
    %{"logs" => logs} = conn.body_params

    logs
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
    |> Enum.each(fn %{"level" => level} = log -> Logger.log(log_level(level), log) end)

    send_resp(conn, 201, [])
  end

  defp log_level("debug"), do: :debug
  defp log_level("error"), do: :error
end
