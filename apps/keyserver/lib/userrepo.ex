defmodule Keyserver.UserRepo do
    use GenServer
    require Logger 
    
    def start_link(path) do
        Logger.debug "Keyserver.UserRepo start_link called #{inspect path}"
        ret = GenServer.start_link(__MODULE__, path, name: __MODULE__)
        Logger.debug "UserRepo start_link end #{inspect ret}"
        ret
    end

    def add(userinfo= %Keyserver.UserInfo{}) do
        Logger.debug "Keyserver.UserRepo add called #{inspect userinfo}"
        GenServer.call __MODULE__, {:add, userinfo}
    end

    def update(userinfo= %Keyserver.UserInfo{}) do
        Logger.debug "Keyserver.UserRepo update called  #{inspect userinfo}"
        GenServer.call __MODULE__, {:update, userinfo}
    end

    def get(username) do
        Logger.debug "Keyserver.UserRepo get called  #{inspect username}"
        GenServer.call __MODULE__, {:get, username}
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
