defmodule UserActorTest do
  use ExUnit.Case
  require Logger

  setup do
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)   
    File.rm(path)
    :ok
  end

  test "Start useractor" do
    u = %Keyserver.UserInfo{username: "ala"}
    {:ok, pid} = Keyserver.UserActor.start_link(u)
    
    {status, _} = catch_exit(Keyserver.UserActor.stop(pid))    
    assert  status == :normal
  end

  test "Add a user and check keys" do
    {:ok, pid} = Keyserver.UserDirectory.register_user("ala@kot.pies", "password")
    #Logger.debug "kkk #{inspect pid}"
    #z = Keyserver.UserActor.get_keys(pid)
  end
end
