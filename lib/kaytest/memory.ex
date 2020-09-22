defmodule Card do
  defstruct text: "", image: "/imgs/placeholder.gif", inuse: true, class: "none"
end

defmodule Memory do
  defstruct text: "bla"

  def addcard(game, card) do
    [card | game]
  end

  def newgame() do
    Enum.shuffle(init())
  end

  def init do
    []
    |> addcard(%Card{text: "Ballon", class: "Ballon"})
    |> addcard(%Card{text: "Baum", class: "Baum"})
    |> addcard(%Card{text: "Banane", class: "Banane"})
    |> addcard(%Card{text: "Herz", class: "Herz"})
    |> addcard(%Card{text: "Ballon", class: "Ballon"})
    |> addcard(%Card{text: "Herz", class: "Herz"})
    |> addcard(%Card{text: "Welt", class: "Welt"})
    |> addcard(%Card{text: "Lastwagen", class: "Lastwagen"})
    |> addcard(%Card{text: "Essen", class: "Essen"})
    |> addcard(%Card{text: "Glas", class: "Glas"})
    |> addcard(%Card{text: "Lastwagen", class: "Lastwagen"})
    |> addcard(%Card{text: "Glas", class: "Glas"})
    |> addcard(%Card{text: "Baum", class: "Baum"})
    |> addcard(%Card{text: "Welt", class: "Welt"})
    |> addcard(%Card{text: "Banane", class: "Banane"})
    |> addcard(%Card{text: "Essen", class: "Essen"})
  end

  def empty do
    []
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
    |> addcard(%Card{text: "dummy", class: "dummy", inuse: false})
  end

  def match(card1, card2) do
    card1.class == card2.class
  end

  def check(game, card1, card2) do
    if match(card1, card2) do
      game
      |> disable_card(card1)
      |> disable_card(card2)
    else
      game
    end
  end

  def disable_card([], _card), do: []

  def disable_card([hd | tl], card) do
    if hd == card do
      [Map.replace!(card, :inuse, false) | disable_card(tl, card)]
    else
      [hd | disable_card(tl, card)]
    end
  end
end
