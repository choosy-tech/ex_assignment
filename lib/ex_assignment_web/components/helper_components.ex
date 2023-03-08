defmodule ExAssignmentWeb.HelperComponents do
  use Phoenix.Component
  import ExAssignmentWeb.CoreComponents

  attr(:value, :integer, default: nil)
  attr(:class, :string, default: nil)

  def todo_prio(assigns) do
    cond do
      assigns.value <= 30 ->
        ~H"""
        <div class="inline-flex items-center gap-1 rounded-full bg-red-200 text-red-600 text-xs px-2 py-1">
          <.icon name="hero-bell-alert" />
          <span><%= @value %></span>
        </div>
        """

      assigns.value <= 60 ->
        ~H"""
        <div class="inline-flex items-center gap-1 rounded-full bg-yellow-200 text-yellow-600 text-xs px-2 py-1">
          <.icon name="hero-bell" />
          <span><%= @value %></span>
        </div>
        """

      true ->
        ~H"""
        <div class="inline-flex items-center gap-1 rounded-full rounded-full bg-gray-200 text-gray-600 text-xs px-2 py-1">
          <.icon name="hero-bell-snooze" />
          <span><%= @value %></span>
        </div>
        """
    end
  end
end
