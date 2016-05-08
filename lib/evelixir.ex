defmodule Evelixir do
    use Application
    require Logger
    
    def start(_type, _args) do 
        Logger.debug "Evelixir.start application started"
        {:ok, pid} = Evelixir.Supervisor.start_link(123) 
    end 
end
