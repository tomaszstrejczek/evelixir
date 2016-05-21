defmodule Keyserver.UserRepo do
    use GenServer
    require Logger 
    
    def start_link(path) do
        Logger.debug "Keyserver.UserRepo start_link called #{inspect path}"
        ret = GenServer.start_link(__MODULE__, path, name: __MODULE__)
        Logger.debug "UserRepo start_link end #{inspect ret}"
        ret
    end

    def add(pid,userinfo= %Keyserver.UserInfo{}) do
        Logger.debug "Keyserver.UserRepo add called #{inspect pid} #{inspect userinfo}"
        GenServer.call pid, {:add, userinfo}
    end

    def update(pid,userinfo= %Keyserver.UserInfo{}) do
        Logger.debug "Keyserver.UserRepo update called #{inspect pid} #{inspect userinfo}"
        GenServer.call pid, {:update, userinfo}
    end

    def get(pid, username) do
        Logger.debug "Keyserver.UserRepo get called #{inspect pid} #{inspect username}"
        GenServer.call pid, {:get, username}
    end

    def handle_call({:add, userinfo}, _from, path) do
        Logger.debug "Keyserver.UserRepo handle_call :add called #{inspect userinfo} #{inspect path}"
        
        {:ok, dets} = :dets.open_file(path, [])
        
        result = :dets.insert_new(dets, {userinfo.username, userinfo})
        
        :dets.close(dets)
               
        {:reply, {:ok, result}, path}
    end 

    def handle_call({:update, userinfo}, _from, path) do
        Logger.debug "Keyserver.UserRepo handle_call :update called #{inspect userinfo} #{inspect path}"
        
        {:ok, dets} = :dets.open_file(path, [])
        
        found = :dets.lookup(dets, userinfo.username)
        
        result = case found do
            [] -> false
            [_] -> :dets.insert(dets, {userinfo.username, userinfo})
        end

        :dets.close(dets)
               
        {:reply, {:ok, result}, path}
    end 

    def handle_call({:get, username}, _from, path) do
        Logger.debug "Keyserver.UserRepo handle_call :get called #{inspect username} #{inspect path}"
        
        {:ok, dets} = :dets.open_file(path, [])
        
        found = :dets.lookup(dets, username)

        :dets.close(dets)
        
        case found do
            [] -> {:reply, :notfound, path}
            [{key, rec}] -> {:reply, {:ok, rec}, path}
        end
    end 
end
