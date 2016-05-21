defmodule Keyserver.Supervisor do
  use Supervisor
  require Logger

  def start_link(initial) do
    Logger.debug "Keyserver.Supervisor start_link called"

    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [initial], name: __MODULE__)
    start_workers(sup, initial)
    result
  end

  @userrepo_name Keyserver.UserRepo

  def start_workers(sup, initial) do
    {:ok, stash} = Supervisor.start_child(
      sup,
      worker(Keyserver.Stash, [%{current_number: initial, delta: 1}])       
    )

    {:ok, path} = Application.fetch_env(:keyserver, :datafile)
    
    {:ok, directory} = Supervisor.start_child(
      sup,
      worker(Keyserver.UserDirectory, [path])       
    )

    {:ok, userrepo} = Supervisor.start_child(
      sup,
      worker(Keyserver.UserRepo, [path])       
    )
    
    z = supervisor(Keyserver.SubSupervisor, [stash])
    ret = Supervisor.start_child(sup, z)
    ret
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end

