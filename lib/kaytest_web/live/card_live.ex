defmodule CardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="column">
      <button phx-click="select" phx-value-cn="<%= @card.text %>"> <%= if @card.inuse do %>
      <img class="animate__flipInX" src="images/back.png">
      <% else %>
      <img class="opacity-25 animate__flipInX" src="images/back.png">
      <% end %></button>
    </div>
    """
  end
end
