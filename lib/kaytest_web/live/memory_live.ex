defmodule KaytestWeb.MemoryLive do
  use KaytestWeb, :live_view
  alias Kaytest.Feedback

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    socket =
      assign_feedback(socket)
      |> assign(:game, Memory.empty())
      |> assign(:moves, 0)
      |> assign(:progress, 0)
      |> assign(:points, 0)
      |> assign(:timerrunning, false)
      |> assign(:gameended, false)
      |> assign(:username, "")
      |> assign(:numberpairs, 4)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(KaytestWeb.PageLiveView, "memory_live.html", assigns)
  end

  @impl true
  def handle_event("select", %{"cn" => card}, socket) do
    {:noreply, assign(socket, :game, Memory.domove(socket.assigns.game, card))}
  end

  @impl true
  def handle_event("newgame", %{}, socket) do
    numpairs = socket.assigns.numberpairs

    socketnew =
      socket
      |> assign(:game, Memory.newgame(numpairs))
      |> assign(:moves, 0)
      |> assign(:progress, 0)
      |> assign(:gameended, false)

    {:noreply, socketnew}
  end

  def handle_event(unknown, parameters, socket) do
    IO.puts("You have to implement the following event")
    IO.puts(unknown)
    IO.inspect(parameters)
    IO.puts("+++++++++++++++++++++++++++++++++++++++++")

    {:noreply, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign_feedback(socket)}
  end

  def handle_info(:incmoves, socket) do
    oldmoves = socket.assigns.moves
    newmoves = oldmoves + 1
    {:noreply, assign(socket, :moves, newmoves)}
  end

  def handle_info(:incpairs, socket) do
    oldpairs = socket.assigns.progress
    newpairs = oldpairs + 1
    oldpoints = socket.assigns.points
    newpoints = oldpoints + 1
    {:noreply, assign(socket, :progress, newpairs) |> assign(:points, newpoints)}
  end

  def handle_info(:finished, socket) do
    moves = socket.assigns.moves
    numpairs = socket.assigns.numberpairs

    {:noreply,
     assign(socket, :gameended, true) |> assign(:numberpairs, Memory.gamesize(moves, numpairs))}
  end

  def handle_info(:turncards, socket) do
    {:noreply, turncards(socket)}
  end

  defp assign_feedback(socket) do
    assign(socket,
      difficulty: Feedback.difficulty()
    )
  end

  defp turncards(socket) do
    game = socket.assigns.game
    a = Memory.getselected(game)
    game1 = Memory.deselect_card(game, a)
    assign(socket, game: Memory.deselect_card(game1, Memory.getselected(game1)))
  end

  def starttimer() do
    Process.send_after(self(), :turncards, 1_000)
  end
end

# defmodule KaytestWeb.MemoryLive do
defmodule KaytestWeb.PageLiveView do
  use KaytestWeb, :view
end
