defmodule Keyserver.UserActorSup do
  use Supervisor
  require Logger

  def start_link() do
    Logger.debug "Keyserver.UserActorSup start_link called"
  
    ret = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    Logger.debug "Keyserver.UserActorSup start_link end #{inspect ret}"
  end

  def init(:ok) do
    Logger.debug "Keyserver.UserActorSup init"
    
    children = [
        worker(Keyserver.UserActor, [], restart: :temporary)
    ]

    x = supervise(children, strategy: :simple_one_for_one)

    Logger.debug "Keyserver.UserActorSup init 2 #{inspect x}"
    x
  end
end

