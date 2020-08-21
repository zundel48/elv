defmodule CardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="column">
      <button phx-click="select" phx-value-cn="<%= @number %>">
         <img src="images/back.png">
      </button>
    </div>
    """
  end
end
