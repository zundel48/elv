defmodule KaytestWeb.MemoryLive do
  use KaytestWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @imple true
  def render(assigns) do
    ~L"""

<div class="container">

  <div class="row">
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
  </div>
  <div class="row">
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>

  </div>
  <div class="row">
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
  </div>
  <div class="row">
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
  </div>
  <div class="row">
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>
    <div class="column">    <img src="/images/back.png"></div>

  </div>

   <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
	  1023
          </span>
          <span class="name">
            Your points
          </span>
        </div>
        <div class="stat">
          <span class="value">
2021
          </span>
          <span class="name">
            Your oponent
          </span>
        </div>
        <div class="stat">
          <span class="value">
    10
          </span>
          <span class="name">
            Learning status
          </span>
        </div>
	</div>

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
end
