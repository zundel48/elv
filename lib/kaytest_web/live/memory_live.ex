defmodule KaytestWeb.MemoryLive do
  use KaytestWeb, :live_view
  alias Kaytest.Feedback

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    socket = assign_feedback(socket)
    |> assign(:game, Memory.empty())
    |> assign(:state, :noselected)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(KaytestWeb.PageLiveView, "memory_live.html", assigns)
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("select", %{"cn" => cardnumber}, socket) do
    # IO.puts("-----------------------")
    # IO.puts(socket.assigns.game)
    # IO.puts("-----------------------")
    #case socket.assigns.state do
    #  :noselected -> assign(socket, :oneselected)
    #  :oneselected -> assign(socket, :noselected)
    #  _ -> true
    #end
    {:noreply, assign(socket, progress: cardnumber)}
  end


  @impl true
  def handle_event("newgame", %{}, socket) do
    
    IO.puts("-----------------------")
    IO.inspect(socket.assigns.game)
    IO.puts("-----------------------")
    newinfo = socket 
    |> assign(:game, Memory.newgame())
    |> assign(:state, :noselected)
    {:noreply, newinfo}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)
         |> assign(kay: %{}, robyn: query)}
    end
  end

  @impl true

  def handle_info(:update, socket) do
    socket = assign_feedback(socket)
    {:noreply, socket}
  end

  defp search(query) do
    if not KaytestWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp assign_feedback(socket) do
    assign(socket,
      difficulty: Feedback.difficulty(),
      points: Feedback.points(),
      progress: Feedback.progress()
    )
  end
end

# defmodule KaytestWeb.MemoryLive do
defmodule KaytestWeb.PageLiveView do
  use KaytestWeb, :view
end
