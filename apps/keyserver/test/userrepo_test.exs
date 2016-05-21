defmodule UserRepoTest do
  use ExUnit.Case
  require Logger 

  test "Add userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :testdatafile)
    
    File.rm(path)
    
    {:ok, pid} = Keyserver.UserRepo.start_link(path)
    
    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.add(pid, u)
    assert r
   
    # insert again
    {:ok, r} = Keyserver.UserRepo.add(pid, u)
    assert !r    
  end

  test "Update userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :testdatafile)
    
    File.rm(path)
    
    {:ok, pid} = Keyserver.UserRepo.start_link(path)

    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.update(pid, u)
    assert !r
    
    # insert & then update
    {:ok, r} = Keyserver.UserRepo.add(pid, u)
    assert r
    u2 = %Keyserver.UserInfo{username: "ala", passwordhash: "newhash"}
    {:ok, r} = Keyserver.UserRepo.update(pid, u2)
    assert r        

    # check if value is updated
    {:ok, rec} = Keyserver.UserRepo.get(pid, "ala")
    assert rec.passwordhash == "newhash"   
  end

  test "get userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :testdatafile)
    
    File.rm(path)
    
    {:ok, pid} = Keyserver.UserRepo.start_link(path)

    check = Keyserver.UserRepo.get(pid, "ala")
    assert check == :notfound

    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.add(pid, u)
    assert r

    {:ok, rec} = Keyserver.UserRepo.get(pid, "ala")
    Logger.debug "check2 #{inspect rec}"
    assert rec.passwordhash == "hash"   
  end

end
