defmodule Keyserver.Server do
    use GenServer
    require Logger 
    
    def start_link(stash_pid) do
        Logger.debug "Keyserver.server start_link called"
        ret = GenServer.start_link(__MODULE__, stash_pid, [name: __MODULE__])
        Logger.debug "Keyserver.server start_link end #{inspect ret}"
        ret
    end
    
    def next_number do 
        GenServer.call __MODULE__, :next_number
    end 
    
    def increment_number(delta) do 
        GenServer.cast __MODULE__, {:increment_number, delta} 
    end

    
    def init(stash_pid) do
        Logger.debug "Keyserver.server init called #{inspect stash_pid}"
     
        current_number = Keyserver.Stash.get_state stash_pid 
        Logger.debug "Keyserver.server 1 #{inspect current_number}"
        { :ok, {current_number.current_number, stash_pid} } 
    end 
    
    def handle_call(:next_number, _from, {current_number, stash_pid}) do 
        { :reply, current_number, {current_number+1, stash_pid }} 
    end
    
    def handle_cast({:increment_number, delta}, {current_number, stash_pid}) do 
        { :noreply, {current_number + delta, stash_pid}} 
    end 
    
    def terminate(_reason, {current_number, stash_pid}) do 
        Logger.debug "Keyserver.server terminate #{inspect current_number} #{inspect stash_pid}"
        Keyserver.Stash.save_state stash_pid, %{current_number: current_number, delta: 1}
    end 
    
end 