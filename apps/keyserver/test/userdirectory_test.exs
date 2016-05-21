defmodule UserDirectoryTest do
  use ExUnit.Case

  test "Call useractor" do
    Keyserver.UserDirectory.register_user("ala@kot.pies", "password")
  end
end
