defmodule PingServerTest do
  use ExUnit.Case
  doctest PingServer

  test "greets the world" do
    assert PingServer.hello() == :world
  end
end
