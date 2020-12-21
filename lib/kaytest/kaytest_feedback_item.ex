defmodule Kaytest.Feedback.Item do
  defstruct id: "",
            text: "",
            image: "/imgs/placeholder.gif",
            sound: "",
            type: :neutral,
            intensity: :strong,
            selected: false,
            class: "none",
            tendency: :neutral,
            strikelength: 0,
            tempo: :normal,
            difficulty: :normal,
            luck: false
end
