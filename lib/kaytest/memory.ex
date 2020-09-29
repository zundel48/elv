defmodule Card do
  defstruct id: "",
            text: "",
            image: "/imgs/placeholder.gif",
            inuse: true,
            selected: false,
            class: "none"
end

defmodule Memory do
  def newgame() do
    Enum.shuffle(init())
  end

  def init do
    [
      %Card{id: "ballon1", text: "Ballon1", class: "Ballon"},
      %Card{id: "baum1", text: "Baum1", class: "Baum"},
      %Card{id: "banane1", text: "Banane1", class: "Banane"},
      %Card{id: "herz1", text: "Herz1", class: "Herz"},
      %Card{id: "ballon2", text: "Ballon2", class: "Ballon"},
      %Card{id: "herz2", text: "Herz2", class: "Herz"},
      %Card{id: "welt1", text: "Welt1", class: "Welt"},
      %Card{id: "lastwagen1", text: "Lastwagen1", class: "Lastwagen"},
      %Card{id: "essen1", text: "Essen1", class: "Essen"},
      %Card{id: "glas1", text: "Glas1", class: "Glas"},
      %Card{id: "lastwagen2", text: "Lastwagen2", class: "Lastwagen"},
      %Card{id: "glas2", text: "Glas2", class: "Glas"},
      %Card{id: "baum2", text: "Baum2", class: "Baum"},
      %Card{id: "welt2", text: "Welt2", class: "Welt"},
      %Card{id: "banane2", text: "Banane2", class: "Banane"},
      %Card{id: "essen2", text: "Essen2", class: "Essen"}
    ]
  end

  def empty do
    Enum.map(1..16, fn _ -> %Card{text: "dummy", class: "dummy", inuse: false} end)
  end

  def match(card1, card2) do
    card1.class == card2.class
  end

  def isselected(game, id) do
    a = select(game, id)
    a.selected
  end

  def getselected(game) do
    Enum.filter(game, fn x -> x.selected end)
    |> Enum.at(0)
  end

  def numberselected(game) do
    Enum.count(Enum.filter(game, fn x -> x.selected end))
  end

  def domove(game, id) do
    ga =
      if numberselected(game) >= 2 do
        deselect_all(game)
      else
        game
      end

    a = getselected(ga)
    b = select(ga, id)

    if b.inuse do
      if a do
        if match(a, b) do
          if a != b do
            newgame =
              ga
              |> disable_card(a)
              |> disable_card(b)
              |> deselect_card(a)

              checkfinished(newgame)
            newgame
          else
            ga
          end
        else
          select_card(ga, b)
        end
      else
        send(self(), :incmoves)
        select_card(ga, b)

      end
    else
      ga
    end
  end

  def isinuse(game, id) do
    a = select(game, id)
    a.inuse
  end

  @spec select(any, any) :: any
  def select(game, id) do
    Enum.filter(game, fn x -> x.id == id end)
    |> Enum.at(0)
  end

  def checkfinished(game) do
    if (Enum.all?(game, fn x -> x.inuse == false end)) do
      send(self(), :finished)
    end
  end

  def select_card(game, card) do
    Enum.map(game, fn x -> if x.id == card.id, do: Map.replace!(x, :selected, true), else: x end)
  end

  def deselect_card(game, nil) do
    game
  end

  def deselect_card(game, card) do
    Enum.map(game, fn x -> if x.id == card.id, do: Map.replace!(x, :selected, false), else: x end)
  end

  def deselect_all(game) do
    Enum.map(game, fn x -> Map.replace!(x, :selected, false) end)
  end

  def disable_card(game, card) do
    Enum.map(game, fn x -> if x.id == card.id, do: Map.replace!(x, :inuse, false), else: x end)
  end
end
