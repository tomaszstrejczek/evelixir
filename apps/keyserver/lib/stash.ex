defmodule Keyserver.Stash do
  use GenServer
  require Logger

  # public API

  def start_link(initial) do
    Logger.debug "Keyserver.Stash start_link called"
  
    {:ok, _pid} = GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def get_state(stash_pid) do
    GenServer.call(stash_pid, :get_state)
  end

  def save_state(stash_pid, state) do
    GenServer.cast(stash_pid, {:save_state, state})
  end

  # GenServer implementation

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:save_state, state}, _old_state) do
    {:noreply, state}
  end
end

