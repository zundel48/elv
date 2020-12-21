defmodule KayTest.FeedbackTest do
  use Kaytest.DataCase
  use ExUnit.Case, async: true
  import Memory
  import Kaytest.Feedback
  alias Kaytest.Feedback.State
  alias Kaytest.Feedback.Indicator

  describe "feedback" do
    setup do
      {:ok, pid} = start_link()
      %{pid: pid}
    end

    test "add event", %{pid: pid} do
      event(pid, "bla")
      event(pid, "bla")
      event(pid, "bla")
      event(pid, "bla")
      newstate = event(pid, "bla")

      assert newstate == :ok
    end

    test "generate new game" do
      assert true
    end

    test "strike of 2" do
      assert countplus([:positive, :positive, :neutral]) == 2
    end

    test "compute empty events correcty" do
      assert countplus([]) == 0
    end

    test "countplus when last event was negative" do
      assert countplus([:negative, :positive, :positive]) == 0
    end

    test "countminus basic functionality" do
      assert countminus([:negative, :neutral, :negative, :negative]) == 3
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

    test "extract last element from event history" do
      state = %State{event_history: ["blubs", "bla"]}
      left = Kaytest.Feedback.last({state, %Indicator{}})
      assert left == {state, %Indicator{last: "blubs"}}
    end

    test "last element is empty string when no event history" do
      state = %State{event_history: []}
      left = Kaytest.Feedback.last({state, %Indicator{}})
      assert left == {state, %Indicator{last: ""}}
    end

    test "strike of four" do
      state = %State{event_history: [:positive, :positive, :neutral, :positive, :positive]}
      left = Kaytest.Feedback.strike({state, %Indicator{}})
      assert left == {state, %Indicator{strike: 4}}
    end

    test "countplus gets the right number" do
      teststring = [:positive, :positive, :positive]
      assert countplus(teststring) == 3
    end

    test "test the tendency_up" do
      state = %State{
        event_history: [:positive, :positive, :neutral, :positive, :positive, :positive]
      }

      left = Kaytest.Feedback.tendency_up({state, %Indicator{}})
      assert left == {state, %Indicator{tendency: :positive}}
    end

    test "test the tendency_down" do
      state = %State{event_history: [:negative, :negative, :neutral, :positive, :positive]}

      left = Kaytest.Feedback.tendency_down({state, %Indicator{}})
      assert left == {state, %Indicator{tendency: :negative}}
    end

    test "test the tendency" do
      state = %State{
        event_history: [:positive, :positive, :neutral, :positive, :positive, :positive]
      }

      left = Kaytest.Feedback.tendency({state, %Indicator{}})
      assert left == {state, %Indicator{tendency: :positive}}
    end

    test "handle_cast prepare um Parameter des Feedbacks zu bestimmen" do
      {:ok, _state} = Kaytest.Feedback.init("")

      state = %State{ event_history: [:positive, :positive, :neutral, :positive, :positive, :positive]}
      state2 = %Kaytest.Feedback.State{event_history: [:positive, :positive, :neutral, :positive, :positive, :positive], feedback_history: [], lasttime: 0, presenter: 0, timing: [], analyse: %Kaytest.Feedback.Indicator{event_history: [], feedback_history: [], last: :positive, lastevent: "", lasttime: 0, presenter: 0, strike: 5, tendency: :positive, timing: []}}

      {:noreply,result} = Kaytest.Feedback.handle_cast({:prepare}, state)
      assert result == state2
    end

    @tag newest: true
    test "handle_cast um neues Element hinzuzfügen" do


      {:ok, _state} = Kaytest.Feedback.init("")

      state = %State{ event_history: [:positive, :positive, :neutral, :positive, :positive, :positive], lasttime: Time.utc_now(), timing: [Time.utc_now()]}
      state1 = %State{ event_history: [:blubs, :positive, :positive, :neutral, :positive, :positive, :positive]}
      {:noreply, result} = Kaytest.Feedback.handle_cast({:actionfeedback, :blubs}, state)
      # remove time related information for now
      result1 = %Kaytest.Feedback.State{result | lasttime: 0, timing: []}
      assert result1 == state1
    end

    test "filter for slow elements" do
     filtereditems =  [
      %Kaytest.Feedback.Item{
        class: "none",
        difficulty: :normal,
        id: "",
        image: "/imgs/placeholder.gif",
        intensity: :medium,
        luck: false,
        selected: false,
        sound: "",
        strikelength: 0,
        tempo: :slow,
        tendency: :neutral,
        text: "Schneller",
        type: :neutral
      },
      %Kaytest.Feedback.Item{
        class: "none",
        difficulty: :normal,
        id: "",
        image: "/imgs/placeholder.gif",
        intensity: :medium,
        luck: false,
        selected: false,
        sound: "",
        strikelength: 0,
        tempo: :slow,
        tendency: :neutral,
        text: "Machst Du gerade eine Pause?",
        type: :neutral
      }
    ]
     result = filter(allfeedbacks(), :tempo, :slow)
    assert filtereditems == result
    end

    test "test the actionfeedback" do
      state = %State{ event_history: [:positive, :positive, :neutral, :positive, :positive, :positive], lasttime: Time.utc_now(), timing: [Time.utc_now()]}
      result = actionfeedback(state)
      goal =  [%Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "aaaah", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "wow", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "vorbildlich", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "phantastisch", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 3, tempo: :normal, tendency: :positive, text: "das machst du souerän", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 3, tempo: :normal, tendency: :positive, text: "du bist ein Naturtalent", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "exzellent", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "überragend", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :positive, text: "immer am Ball bleiben", type: :negative}]


      assert result == goal
    end

    test "test the actionfeedback with no real tendency " do
      state = %State{ event_history: [:positive, :negative, :positive, :negative, :positive], lasttime: Time.utc_now(), timing: [Time.utc_now()]}
      result = actionfeedback(state)
      goal =  [%Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "bald kommt etwas Neues", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Perfekt", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "ja, genau so", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "jaaaaa", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "bald kommt etwas Neues", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :weak, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "hmmm", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Mensch.... ", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "ach Pech", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "bald kommt etwas Neues", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "oh, nein", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Tolle Serie", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 5, tempo: :normal, tendency: :neutral, text: "5 richtig ohne Fehler", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 10, tempo: :normal, tendency: :neutral, text: "10 richtig ohne Fehler", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Du wirst immer besser", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :strong, luck: false, selected: false, sound: "", strikelength: 12, tempo: :normal, tendency: :neutral, text: "Yeah, von der Serie wirst du morgen noch träumen", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/like.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :weak, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Hätte ich genauso gemacht", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :weak, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Das hätte ich auch gekommt", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Ich schau dir gerne beim Spielen zu", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :slow, tendency: :neutral, text: "Schneller", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :slow, tendency: :neutral, text: "Machst Du gerade eine Pause?", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :fast, tendency: :neutral, text: "Nicht so hektisch", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Du hast recht", type: :positive}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :weak, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "hmmm", type: :negative}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :weak, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "aha", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :high, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: false, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Das war schwierig", type: :neutral}, %Kaytest.Feedback.Item{class: "none", difficulty: :normal, id: "", image: "/imgs/placeholder.gif", intensity: :medium, luck: true, selected: false, sound: "", strikelength: 0, tempo: :normal, tendency: :neutral, text: "Manchmal braucht man Glück", type: :neutral}]


      assert result == goal
    end

    test "actionfeedback with negative tendency" do
      state = %State{ event_history: [:negative, :negative, :positive, :negative, :positive], lasttime: Time.utc_now(), timing: [Time.utc_now()]}
      result = actionfeedback(state)
      # IO.inspect(result)
      assert (List.first(result).tendency == :negative)
    end

    test "initial competence" do
      assert(competence([]) == :neutral)
    end

    test "competence increase with positive event" do
      # assert_in_delta(competence([:positive]), 0.65, 0.01 )
      assert(competence([:positive]) == :positive)
    end

    test "competence stays the same  with neutral event" do
      assert(competence([:neutral]) == :neutral)
    end

    test "competence of sequence of events" do
      #assert_in_delta(competence([:positive, :neutral, :negative],), 0.54, 0.01 )
      assert(competence([:positive, :neutral, :negative]) == :neutral)
    end

    test "competence of sequence of double negative" do
      #assert_in_delta(competence([:negative, :neutral, :negative]), 0.245, 0.01 )
      assert(competence([:negative, :neutral, :negative]) == :negative)

    end

  end
end
