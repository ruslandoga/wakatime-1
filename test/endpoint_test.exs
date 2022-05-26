defmodule W1.EndpointTest do
  use W1.ConnCase, async: true

  @opts @endpoint.init([])

  describe "POST /heartbeats" do
    test "with valid payload" do
      conn =
        conn(:post, "/heartbeats", %{
          "_json" => [
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
        })

      conn = @endpoint.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 201
      assert Jason.decode!(conn.resp_body) == %{"responses" => [[nil, 201]]}

      assert W1.Repo.aggregate("heartbeats", :count) == 1
    end
  end
end
