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
        Logger.debug "Keyserver.UserActor start_link called"
        ret = GenServer.start_link(__MODULE__, userinfo)
        Logger.debug "UserActor start_link end #{inspect ret}"
        ret
    end

    def stop(pid) do
        GenServer.call(pid, :stop)
    end 
    
    def init(userinfo) do
        { :ok, {userinfo} } 
    end 
    

    def handle_call(:stop, _from, status) do
        {:stop, :normal, status}
    end 

    def terminate(reason, _status) do
        Logger.debug "Keyserver.UserActor Asked to stop because #{inspect reason}"
        :ok 
    end         
end
