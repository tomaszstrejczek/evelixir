defmodule CliTest do 
    use ExUnit.Case
    doctest Evelixir
   
    import Evelixir.CLI, only: [ parse_args: 1 ] 
    
    test ":help returned by option parsing with -h and --help options" do 
        assert parse_args(["-h", "anything"]) == :help 
        assert parse_args(["--help", "anything"]) == :help
    end    

    test ":addkey returned by option parsing with --addkey options" do 
        assert parse_args(["--addkey", "anything"]) == :addkey 
    end    
end 