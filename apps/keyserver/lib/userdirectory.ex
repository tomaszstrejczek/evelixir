defmodule Keyserver.UserDirectory do
    use GenServer
    require Logger 
    
    def start_link() do
        Logger.debug "Keyserver.UserDirectory start_link"
        ret = GenServer.start_link(__MODULE__, [], name: __MODULE__)
        Logger.debug "UserDirectory start_link end"
        ret
    end

    def register_user(username, password) do
        GenServer.call __MODULE__, {:register_user, {username, password}}
    end

    def handle_call({:register_user, {username, password}}, _from, []) do
        Logger.debug "Keyserver.UserDirectory handle_call register_user called"
        
        u = %Keyserver.UserInfo{username: username, passwordhash: password}
        case Keyserver.UserRepo.add(u) do
            {:ok, true} -> 
                z = Supervisor.start_child(Keyserver.UserActorSup, [u])
                {:ok, pid} = z
                {:reply, {:ok, pid}, []}
            {:ok , false} ->
                {:reply, :duplicate, []}
        end
    end 
end
