defmodule Evelixir.CLI do

    @moduledoc """ 
    Handle the command line parsing and the dispatch to the various functions that are used to administer the system 
    """ 
    def start(argv) do
        argv 
        |> parse_args
        |> process         
    end

    def parse_args(argv) do 
        parse = OptionParser.parse(argv,
             switches: [ help: :boolean, addkey: :boolean], 
             aliases: [ h: :help ]) 
        case parse do
             { [ help: true ], _, _ } -> :help
             { [ addkey: true ], _, _ } -> :addkey
             _ -> :help 
        end
    end
    
    def process(:help) do 
        IO.puts """ 
        usage:
        """
        System.halt(0) 
    end       

    def process(:addkey) do 
        IO.puts """ 
        addkey:
        """
        System.halt(0) 
    end       

end