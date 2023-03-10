defmodule ExAssignment.RecommendationServer do
  use GenServer
  @process_name :recommendation_server

  # Client

  def get_recommendation() do
    GenServer.call(@process_name, :get)
  end

  def set_recommendation(recommendation) do
    GenServer.cast(@process_name, {:set, recommendation})
  end

  def invalidate_recommendation() do
    GenServer.cast(@process_name, {:set, nil})
  end

  # Server

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{recommendation: nil}, name: @process_name)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:get, _, state) do
    {:reply, Map.get(state, :recommendation), state}
  end

  def handle_cast({:set, recommendation}, state) do
    {:noreply, Map.put(state, :recommendation, recommendation)}
  end
end
