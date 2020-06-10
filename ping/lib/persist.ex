require Logger

defmodule PingServer.Persist do
  use GenServer

  @ten_seconds 10_000

  def start_link(arg) do
    :ets.new(:counters, [:public, :named_table])

    case File.exists? "dets_counters" do
      true ->
        :dets.open_file(:dets_counters, [])
        :dets.to_ets(:dets_counters, :counters)
        :dets.close(:dets_counters)
      false ->
        :ets.insert(:counters, {:processed_beats, 0})
    end

    GenServer.start_link(__MODULE__, arg)
  end

  def init(opts) do
    Process.send_after(self(), :flush_to_disk, @ten_seconds)

    {:ok, opts}
  end

  def handle_info(:flush_to_disk, state) do
    :dets.open_file(:dets_counters, [])
    :ets.to_dets(:counters, :dets_counters)
    :dets.close(:dets_counters)

    Logger.debug("Flushed entries to disk!")

    Process.send_after(self(), :flush_to_disk, @ten_seconds)

    {:noreply, state}
  end
end
