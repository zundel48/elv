defmodule CardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="column animate_animated aanimate__flipInX">
      <button phx-click="select" phx-value-cn="<%= @card.id %>"> <%= if @card.inuse do %>
      <img class="animate__flipInX" src="images/back.png">
      <% else %>
      <img class="opacity-25 animate_animated aanimate__flipInX" src="/images/back.png">
      <% end %></button>
    </div>
    """
  end
end
