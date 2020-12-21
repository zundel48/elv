defmodule Kaytest.Feedback do

  @moduledoc """
  There is a differnce between tendency and competence
  competence is computed by a a sequence, weighing newer events higher than older events
  in contrast the tendency looks for the last 2 non-neutral events. A tendency exists when these two elements
  coincide.
  It is possible to have an competence increase in the session while having a negative tendency.

  tendency does not allow any interruptions of he series and describes a strike, while an incerease of competence does
  not have to be error free
  """

  use GenServer
  use Kaytest.Feedback.Helper
  alias Kaytest.Feedback.State
  alias Kaytest.Feedback.Indicator
  alias Kaytest.Feedback.Item

 #  @probtime 50 # probability in percent that feedback is give when too slow
  @probtime 100 # during development feedback is given all the time
  # @probaction 50 # probabilty in percent that feedback is given after an action
  @probaction 100 # during development feedback is giben all the time
  # we add a timout element which is a special case of a negative element, that in not result of an action
  @competencediff 0.1

  @allfeedbacks [
    %Item{text: "bald kommt etwas Neues", type: :positive, intensity: :strong},
    %Item{text: "Perfekt", type: :positive, intensity: :strong},
    %Item{text: "ja, genau so", type: :positive, intensity: :medium},
    %Item{text: "jaaaaa", type: :positive, intensity: :strong},
    %Item{text: "bald kommt etwas Neues", type: :positive, intensity: :strong},
    %Item{text: "hmmm", type: :negative, intensity: :weak},
    %Item{text: "Mensch.... ", type: :negative, intensity: :medium},
    %Item{
      text: "aaaah",
      type: :negative,
      tendency: :positive,
      intensity: :medium
    },
    %Item{text: "ach Pech", type: :negative, intensity: :medium},
    %Item{text: "bald kommt etwas Neues", type: :positive, intensity: :strong},
    %Item{text: "oh, nein", type: :negative, intensity: :medium},
    %Item{text: "Tolle Serie", type: :positive, intensity: :medium},
    %Item{
      text: "5 richtig ohne Fehler",
      type: :positive,
      intensity: :strong,
      strikelength: 5
    },
    %Item{
      text: "10 richtig ohne Fehler",
      type: :positive,
      intensity: :strong,
      strikelength: 10
    },
    %Item{text: "Du wirst immer besser", type: :positive, intensity: :medium},
    %Item{
      text: "Yeah, von der Serie wirst du morgen noch träumen",
      type: :positive,
      intensity: :strong,
      strikelength: 12
    },
    %Item{image: "/imgs/like.gif", type: :positive, intensity: :medium},
    %Item{text: "Hätte ich genauso gemacht", type: :positive, intensity: :weak},
    %Item{text: "Das hätte ich auch gekommt", type: :positive, intensity: :weak},
    %Item{
      text: "Ich schau dir gerne beim Spielen zu",
      type: :neutral,
      intensity: :medium
    },
    %Item{text: "Schneller", intensity: :medium, tempo: :slow},
    %Item{
      text: "Machst Du gerade eine Pause?",
      intensity: :medium,
      tempo: :slow
    },
    %Item{
      text: "Jetzt nicht die Nerven verlieren",
      tendency: :negative,
      intensity: :medium,
      tempo: :fast
    },
    %Item{
      text: "Nicht so hektisch",
      tendency: :neutral,
      intensity: :medium,
      tempo: :fast
    },
    %Item{
      text: "Zurücklehnen und tief durchatmen",
      tendency: :negative,
      intensity: :medium,
      tempo: :fast
    },
    %Item{text: "Du hast recht", type: :positive, intensity: :medium},
    %Item{text: "wow", tendency: :positive, intensity: :medium},
    %Item{text: "vorbildlich", tendency: :positive, intensity: :strong},
    %Item{text: "phantastisch", tendency: :positive, intensity: :strong},
    %Item{
      text: "das machst du souerän",
      tendency: :positive,
      intensity: :medium,
      strikelength: 3
    },
    %Item{
      text: "du bist ein Naturtalent",
      tendency: :positive,
      intensity: :medium,
      strikelength: 3
    },
    %Item{
      text: "wir schaffen das",
      type: :negative,
      tendency: :negative,
      intensity: :medium,
      strikelength: 3
    },
    %Item{
      text: "Nicht übermütig werden",
      tendency: :negative,
      intensity: :weak,
      tempo: :fast
    },
    %Item{text: "exzellent", tendency: :positive, intensity: :medium},
    %Item{text: "überragend", tendency: :positive, intensity: :strong},
    %Item{
      text: "das kannst du besser",
      type: :negative,
      tendency: :negative,
      intensity: :strong,
      strikelength: 3
    },
    %Item{
      text: "immer am Ball bleiben",
      type: :negative,
      tendency: :positive,
      intensity: :medium
    },
    %Item{
      text: "manchmal klaptts nicht so richtig",
      type: :negative,
      tendency: :negative,
      intensity: :medium
    },
    %Item{
      text: "bingo",
      type: :positive,
      tendency: :negative,
      intensity: :medium
    },
    %Item{text: "hmmm", type: :negative, tendency: :neutral, intensity: :weak},
    %Item{text: "aha", tendency: :neutral, intensity: :weak},
    %Item{text: "Das war schwierig", intensity: :medium, difficulty: :high},
    %Item{text: "Manchmal braucht man Glück", intensity: :medium, luck: true}
  ]

  def allfeedbacks() do
    @allfeedbacks
  end
  def points do
    Enum.random(1000..2000)
  end

  def difficulty do
    Enum.random(20..45)
  end

  def progress do
    Enum.random(1..55)
  end

  def init(_init_arg) do
    {:ok, %State{}}
  end

  def filter(_x) do
    @allfeedbacks
  end

  def filter(list, key, value) do
    Enum.filter(list, & Map.get(&1, key) ==  value)
  end

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def event(pid, value) do
    GenServer.cast(pid, {:event, value})
  end

  def handle_cast({:actionfeedback, value}, state) do
    newstate = %State{
      state
      | event_history: [value] ++ state.event_history ,
        timing: [Time.diff(Time.utc_now(), state.lasttime)] ++ state.timing ,
        lasttime: Time.utc_now()
    }
    # at this point we have to reset the timer
    {:noreply, newstate}
  end

  def handle_cast({:prepare}, state) do
    {:noreply, %State{state | analyse: elem({state, %Kaytest.Feedback.Indicator{}} |> tendency |> strike |> last, 1)}}
  end


  def handle_cast({:timerfeedback}, state) do
    # look for the intensity
    if (Enum.random(0..100) <= @probtime) do
      feedbacks =  filter(@allfeedbacks, :tempo, :slow)
      Enum.random(feedbacks)
      # send feedback to frontend
    end
    {:noreply, state}
  end

  def handle_cast(default, state) do
    IO.puts "received message " <> default <> ", but don't know what to do with it"
    {:noreply, state}
  end


  def actionfeedback(state) do
    if (Enum.random(0..100) <= @probaction) do
      indicator = %Indicator{}
      {_state1, indicator1 } = tendency({state, indicator})
      feedbacks =  filter(@allfeedbacks, :tendency, indicator1.tendency)
      # IO.inspect(tstate)

      feedbacks
    end
  end



  # how do I determine the intensity of the feedback.
  # it is based on the feedback_history
  # repeated feedback gets more intense mild middle strong.maybe_improper_list()
  # so wie also have to remember the intesity of last feedback
  # the actual feedback we gave ist not as important as the parameters of it.
  # intensity does not have 100% predictable but can give a probability

  @type state() :: %Kaytest.Feedback.State{}
  @type indicator() :: %Kaytest.Feedback.Indicator{}

  @spec tendency({state(), indicator()}) :: {state(), indicator()}

  def tendency({state, indicator}) do

    newindicator =
      {state, indicator}
      |> tendency_up()
      |> tendency_down()

    newindicator
  end

  @spec strike({state(), indicator()}) :: {state(), indicator()}
  def strike({state, indicator}) do
    goback = state.event_history
    {state, %Indicator{indicator | strike: countplus(goback, 0)}}
  end

  @spec tendency_up({state(), indicator()}) :: {state(), indicator()}
  def tendency_up({state, indicator}) do
    goback = state.event_history

    if countplus(goback) >= 2 do
      {state, %Indicator{indicator | tendency: :positive}}
    else
      {state, indicator}
    end
  end

  @spec tendency_down({state(), indicator()}) :: {state(), indicator()}
  def tendency_down({state, indicator}) do
    goback = state.event_history

    if countminus(goback) >= 2 do
      {state, %Indicator{indicator | tendency: :negative}}
    else
      {state, indicator}
    end
  end

  @spec last({state(), indicator()}) :: {state(), indicator()}
  def last({state, indicator}) do
    goback = state.event_history

    if Enum.count(goback) >= 1 do
      [hd | _tl] = goback
      {state, %Indicator{indicator | last: hd}}
    else
      {state, indicator}
    end
  end

  def sessioncompetence(x) do
    competence(x)
  end

  def shortcompetence(sequence, init) do
    competence(Enum.slice(sequence, 0, 10), init) - init
    |> diffdelta(@competencediff)
  end

  def competence (x) do
    (competence(x, 0.5) - 0.5)
    |> diffdelta(@competencediff)
  end

  def diffdelta(x, delta) do
    cond  do
      x > delta -> :positive
      x < -delta -> :negative
      True  -> :neutral
    end
  end

  def competence([], v) do
    v
  end

  def competence([h|t],v)  do
    case h do
      :positive -> competence(t,v) * 0.7 + 0.3
      :negative -> competence(t,v) * 0.7
      :neutral  -> competence(t,v)
    end
  end

end
