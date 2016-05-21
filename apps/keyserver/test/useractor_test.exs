defmodule UserActorTest do
  use ExUnit.Case

  test "Start useractor" do
    u = %Keyserver.UserInfo{username: "ala"}
    {:ok, pid} = Keyserver.UserActor.start_link(u)
    
    {status, _} = catch_exit(Keyserver.UserActor.stop(pid))    
    assert  status == :normal
  end
end
