defmodule UserDirectoryTest do
  use ExUnit.Case

  setup do
    {:ok, path} = Application.fetch_env(:keyserver, :datafile)   
    File.rm(path)
    :ok
  end

  test "Sanity check" do
    {:ok, pid} = Keyserver.UserDirectory.register_user("ala@kot.pies", "password")
  end

#  test "Duplicate register" do
#    {:ok, pid} = Keyserver.UserDirectory.register_user("ala@kot.pies", "password")

#    :duplicate = Keyserver.UserDirectory.register_user("ala@kot.pies", "password")
#  end

end
