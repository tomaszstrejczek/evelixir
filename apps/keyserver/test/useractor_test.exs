defmodule UserActorTest do
  use ExUnit.Case

  test "Start useractor" do
    u = %Keyserver.UserInfo{username: "ala"}
    {:ok, pid} = Keyserver.UserActor.start_link(u)

    Process.flag(:trap_exit, true)
    #Process.unlink(pid)   
    
    Keyserver.UserActor.stop(pid)
    #Process.exit(pid, :normal)
      
    assert_receive :normal           
  end
end
