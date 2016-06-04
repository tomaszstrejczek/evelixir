defmodule UserRepoTest do
  use ExUnit.Case
  require Logger 

  test "Add userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)   
    File.rm(path)
    
    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.add(u)
    assert r
   
    # insert again
    {:ok, r} = Keyserver.UserRepo.add(u)
    assert !r    
  end

  test "Update userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)
    
    File.rm(path)
    
    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.update(u)
    assert !r
    
    # insert & then update
    {:ok, r} = Keyserver.UserRepo.add(u)
    assert r
    u2 = %Keyserver.UserInfo{username: "ala", passwordhash: "newhash"}
    {:ok, r} = Keyserver.UserRepo.update(u2)
    assert r        

    # check if value is updated
    {:ok, rec} = Keyserver.UserRepo.get("ala")
    assert rec.passwordhash == "newhash"   
  end

  test "Update userinfo with keys" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)
    
    File.rm(path)
    
    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.add(u)
    assert r
    
    k = %Keyserver.KeyInfo{keyid: 10, vcode: "vcode"}
    u2 = %{u | keys: u.keys ++ k}
    
    # Update
    {:ok, r} = Keyserver.UserRepo.update(u2)
    assert r        

    # check if value is updated
    {:ok, rec} = Keyserver.UserRepo.get("ala")
    assert rec.passwordhash == "hash"   
    assert k == rec.keys   
  end

  test "get userinfo" do
  
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)
    
    File.rm(path)
    
    check = Keyserver.UserRepo.get("ala")
    assert check == :notfound

    u = %Keyserver.UserInfo{username: "ala", passwordhash: "hash"}
    {:ok, r} = Keyserver.UserRepo.add(u)
    assert r

    {:ok, rec} = Keyserver.UserRepo.get("ala")
    assert rec.passwordhash == "hash"   
  end

end
