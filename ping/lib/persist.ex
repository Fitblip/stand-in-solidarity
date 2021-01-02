require Logger

defmodule PingServer.Persist do
  use GenServer

  @ten_seconds 10_000

  def start_link(arg) do
    :ets.new(:counters, [:public, :named_table])
    case Redix.command(:redis, ["GET", "heartbeat_count"]) do
      {:ok, nil} -> 
        Redix.command(:redis, ["SET", "heartbeat_count", 0])
        :ets.insert(:counters, {:processed_beats, 0})
      {:ok, number} -> 
        :ets.insert(:counters, {:processed_beats, number |> Integer.parse |> elem(0)})
    end

    GenServer.start_link(__MODULE__, arg)
  end

  def init(opts) do
    Process.send_after(self(), :flush_to_disk, @ten_seconds)

    {:ok, opts}
  end

  def handle_info(:flush_to_disk, state) do
    processed_beats = :ets.lookup(:counters, :processed_beats) |> Keyword.get(:processed_beats, 0)

    Redix.command(:redis, ["SET", "heartbeat_count", processed_beats])

    Logger.debug("Flushed entries to disk!")

    Process.send_after(self(), :flush_to_disk, @ten_seconds)

    {:noreply, state}
  end
end
