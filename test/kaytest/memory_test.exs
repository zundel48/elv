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
      game = Memory.init(8)
      assert length(game) == 16
    end

    test "a shuffeled game if different (most of the time)" do
      refute Memory.init(8) == newgame(8)
    end
  end
end
