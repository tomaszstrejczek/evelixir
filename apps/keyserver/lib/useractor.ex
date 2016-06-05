defmodule Keyserver.KeyInfo do
    defstruct keyid: 0, vcode: ""
end

defmodule Keyserver.UserInfo do
    defstruct username: "", passwordhash: "", keys: []
end

defmodule Keyserver.UserActor do
    use GenServer
    require Logger 
    
    def start_link(userinfo) do
        Logger.debug "zzz Keyserver.UserActor start_link called #{inspect userinfo}"
        ret = GenServer.start_link(__MODULE__, userinfo)
        Logger.debug "UserActor start_link end #{inspect ret}"
        ret
    end

    def stop(pid) do
        GenServer.call(pid, :stop)
    end 

    def get_keys(pid) do
        GenServer.call(pid, :get_keys)
    end 

    def add_key(pid, keyid, vcode) do
        GenServer.call(pid, :add_key, keyid, vcode)
    end 
    
    def init(userinfo) do
        { :ok, {userinfo} } 
    end 
    

    def handle_call(:stop, _from, {state = %Keyserver.UserInfo{}}) do
        {:stop, :normal, state}
    end 

    def handle_call(:get_keys, _from, {state = %Keyserver.UserInfo{}}) do
        {:reply, state.keys, state}
    end 

    def handle_call(:add_keys, _from, {state = %Keyserver.UserInfo{}}) do
        {:reply, state.keys, state}
    end 

    def terminate(reason, _status) do
        Logger.debug "Keyserver.UserActor Asked to stop because #{inspect reason}"
        :ok 
    end         
end
