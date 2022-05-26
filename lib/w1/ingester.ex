defmodule W1.Ingester do
  alias W1.Repo

  def insert_heartbeats(heartbeats) do
    Repo.insert_all("heartbeats", parse_heartbeats(heartbeats))
    :ok
  end

  @doc false
  def parse_heartbeats(heartbeats) do
    Enum.map(heartbeats, fn %{"time" => time, "user_agent" => user_agent} = hb ->
      ["wakatime/" <> _wakatime_version, os, _python_or_go_version, editor, _extension] =
        String.split(user_agent, " ")

      os = String.replace(os, ["(", ")"], "")

      %{hb | "time" => DateTime.from_unix!(round(time * 10_000_000), 10_000_000)}
      |> Map.delete("user_agent")
      |> Map.put("editor", editor)
      |> Map.put("operating_system", os)
      |> Map.update("is_write", nil, fn is_write -> !!is_write end)
    end)
  end
end
