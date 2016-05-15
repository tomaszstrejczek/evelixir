defmodule Keyserver.SubSupervisor do
  use Supervisor
  require Logger

  def start_link(stash_pid) do
    Logger.debug "Keyserver.SubSupervisor start_link called"
  
    ret = Supervisor.start_link(__MODULE__, stash_pid, name: __MODULE__)
    Logger.debug "Keyserver.SubSupervisor start_link end #{inspect ret}"
  end

  def init(stash_pid) do
    Logger.debug "Keyserver.SubSupervisor init #{inspect stash_pid}"
    
    child_processes = [worker(Keyserver.Server, [stash_pid])]
    x = supervise child_processes, strategy: :one_for_one

    Logger.debug "Keyserver.SubSupervisor init 2 #{inspect x}"
    x
  end
end

