defmodule W1.IngesterTest do
  use W1.DataCase, async: true

  test "parse_heartbeats" do
    heartbeats = [
      %{
        "branch" => "add-ingester",
        "category" => "coding",
        "cursorpos" => 1,
        "dependencies" => nil,
        "entity" => "/Users/q/Developer/copycat/w1/test/endpoint_test.exs",
        "is_write" => nil,
        "language" => "Elixir",
        "lineno" => 1,
        "lines" => 4,
        "project" => "w1",
        "time" => 1_653_576_917.486633,
        "type" => "file",
        "user_agent" =>
          "wakatime/v1.45.3 (darwin-21.4.0-arm64) go1.18.1 vscode/1.68.0-insider vscode-wakatime/18.1.5"
      }
    ]

    assert W1.Ingester.parse_heartbeats(heartbeats) == [
             %{
               "branch" => "add-ingester",
               "category" => "coding",
               "cursorpos" => 1,
               "dependencies" => nil,
               "editor" => "vscode/1.68.0-insider",
               "entity" => "/Users/q/Developer/copycat/w1/test/endpoint_test.exs",
               "is_write" => false,
               "language" => "Elixir",
               "lineno" => 1,
               "lines" => 4,
               "operating_system" => "darwin-21.4.0-arm64",
               "project" => "w1",
               "time" => ~U[2022-05-26 14:55:17.486633Z],
               "type" => "file"
             }
           ]
  end
end
