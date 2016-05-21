defmodule Keyserver.UserDirectory do
    use GenServer
    require Logger 
    
    def start_link(path) do
        Logger.debug "Keyserver.UserDirectory start_link called #{inspect path}"
        ret = GenServer.start_link(__MODULE__, path, name: __MODULE__)
        Logger.debug "UserDirectory start_link end #{inspect ret}"
        ret
    end


    def register_user(email, password) do
        GenServer.call __MODULE__, {:register_user, {email, password}}
    end

    def handle_call({:register_user, {email, password}}, _from, path) do
        "Keyserver.UserDirectory handle_call register_user called #{inspect path}"
        
        {:reply, "", path}
    end 
end
