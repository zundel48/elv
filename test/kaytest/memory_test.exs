defmodule KayTest.MemoryTest do
  use Kaytest.DataCase
  import Memory

  describe "memory" do
    test "generate new game" do
      assert true
    end

    test "compare two equivalent cards" do
      a = %Card{text: "Ballon", class: "Ballon"}
      assert match(a, a)
    end

    test "compare two different concepts" do
      a = %Card{text: "Ballon", class: "Ballon"}
      b = %Card{text: "Hammer", class: "Hammer"}
      refute match(a, b)
    end

    test "an freshly initialized Game has 16 cards" do
      game = Memory.init()
      assert (length(game) == 16)
    end
      
    test "a shuffeled game if different (most of the time)" do
      refute Memory.init() == newgame(Memory.init())
    end

    test "check on pair will result in unmodified game " do
      game = Memory.init()
      a = %Card{text: "Ballon", class: "Ballon"}
      b = %Card{text: "Hammer", class: "Hammer"}
      assert check( game, a, b) == game
    end

    test "with matching part change game" do
      game = Memory.init()
      a = %Card{text: "Ballon", class: "Ballon"}
      refute check( game, a, a) == game
    end

    test "updated game afte check has still 16 cards" do
      game = Memory.init()
      a = %Card{text: "Ballon", class: "Ballon"}
      assert length( check( game, a, a)) == 16
    end

    
    
  end
end
