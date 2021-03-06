defmodule PingServer do
  use Application

  def start(_type, _args) do
    children = [
      {Redix, {System.get_env("REDIS_URL", "redis://127.0.0.1:6379/0"), [name: :redis]}},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: nil,
        options: [
          dispatch: dispatch(),
          port: System.get_env("PORT", "4000")
                |> String.to_integer
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.PingServer
      ),
      PingServer.Persist,
    ]

    opts = [strategy: :one_for_one, name: PingServer.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/ws/", PingServer.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {PingServer.Router, []}}
        ]
      }
    ]
  end
end
