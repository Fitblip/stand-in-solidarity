require Logger

defmodule PingServer.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    {:cowboy_websocket, request, request}
  end

  def websocket_init(state) do
    broadcast_message("new_connection")

    Registry.PingServer
      |> Registry.register("broadcast", {})

    Logger.info("New client connected #{state.headers["cf-connecting-ip"]} - #{state.headers["cf-ipcountry"]} - #{state.headers["user-agent"]}")

    {:ok, state}
  end

  def websocket_handle({:text, "heartbeat"}, state) do
    Logger.info("Received ping from #{state.headers["cf-connecting-ip"]} - #{state.headers["cf-ipcountry"]}")

    :ets.update_counter(:counters, :processed_beats, 1)

    broadcast_message("ping")

    {:ok, state}
  end

  def websocket_handle({:text, "ping"}, state) do
    Logger.info("Received ping from #{state.headers["cf-connecting-ip"]} - #{state.headers["cf-ipcountry"]}")

    :ets.update_counter(:counters, :processed_beats, 1)

    broadcast_message("ping")

    {:ok, state}
  end

  def websocket_handle({:text, "."}, state) do
    {:ok, state}
  end

  def websocket_handle({:text, text}, state) do
    Logger.info("Unknown data recv - #{text}")
    {:ok, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  def broadcast_message(message) do
    Registry.PingServer
    |> Registry.dispatch("broadcast", fn(entries) ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)
  end

  def terminate(reason, partial_req, state) do
    Logger.info("Client disconnected #{state.headers["cf-connecting-ip"]} - #{state.headers["cf-ipcountry"]} - #{state.headers["user-agent"]}")
    broadcast_message("disconnected_client")
    :ok
  end

end
