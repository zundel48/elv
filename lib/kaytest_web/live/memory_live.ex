defmodule KaytestWeb.MemoryLive do
  use KaytestWeb, :live_view
  alias Kaytest.Feedback
  
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    :timer.send_interval(1000, self(), :update)
    
    socket = assign_feedback(socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""


     <h1 class="text-yellow-500 text-5xl font-bold text-center">Memory Challenge</h1>

     <div class="space-x-10 bg-grey rounded overflow-hidden  border-l  border-gray-400 p-4 p-10 flex justify-center" style="">
       <div class=" rounded overflow-hidden shadow-lg w-2/3">

         <div class="grid grid-cols-4 sm:grid-cols-5 md:grid-cols-5 lg:grid-cols-6 xl:grid-cols-6">
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 <div class="column">    <img src="/images/back.png"></div>
	 
    </div>
    </div> 


    <div class="space-y-2 w-1/3">

    <button class="bg-gray-200 hover:bg-gray-200  p-3 py-2 w-full rounded-lg text-gray-700 gap-4 xl:text-3xl desktop:text-yellow-500">
    <div class="grid grid-cols-2 gap-4">
    <div>Difficulty:</div><div><%= @difficulty %></div>
    </button>
    <button class="bg-gray-200 hover:bg-gray-200  p-3 py-2 w-full rounded-lg text-gray-700 xl:text-3xl">
    <div class="grid grid-cols-2 gap-4">
    <div>Points:</div><div><%= @points %> </div>
    </div>
    </button>
    <button class="bg-gray-200 hover:bg-gray-200  p-3 py-2 w-full rounded-lg text-gray-700 xl:text-3xl">
    <div class="grid grid-cols-2 gap-4">
    <div>Progress:</div><div><%= @progress %></div>
    </div>
    </button>

    <button class="bg-gray-200 hover:bg-gray-200  p-3 py-15 w-full rounded-lg text-gray-700">
    Here is some additional text that will allow us to inform the user about progress or others. Whatever you do, you will always be my number 1 
    </div>
    </button>

    </div>


    </div></div></div>

      <button phx-click="refresh">
        <img src="images/back.png">
        Refresh
      </button>

    """
    
  end

  
  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
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
         |> assign(results: %{}, query: query)}
    end
  end

  def handle_info(:update, socket) do
    socket = assign_feedback(socket)
    IO.puts("this function was called")
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
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
