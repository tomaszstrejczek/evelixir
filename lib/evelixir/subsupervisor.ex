defmodule Evelixir.SubSupervisor do
  use Supervisor
  require Logger

  def start_link(stash_pid) do
    Logger.debug "Evelixir.SubSupervisor start_link called"
  
    ret = Supervisor.start_link(__MODULE__, stash_pid, name: __MODULE__)
    Logger.debug "Evelixir.SubSupervisor start_link end #{inspect ret}"
  end

  def init(stash_pid) do
    Logger.debug "Evelixir.SubSupervisor init #{inspect stash_pid}"
    
    child_processes = [worker(Evelixir.KeyServer, [stash_pid])]
    x = supervise child_processes, strategy: :one_for_one

    Logger.debug "Evelixir.SubSupervisor init 2 #{inspect x}"
    x
  end
end

