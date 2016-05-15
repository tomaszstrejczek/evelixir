defmodule Keyserver do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.debug "Keyserver.start"
    {:ok, pid} = Keyserver.Supervisor.start_link(123) 
  end
end
