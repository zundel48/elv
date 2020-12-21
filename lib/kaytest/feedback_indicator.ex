defmodule Kaytest.Feedback.Indicator do
  @type t :: %__MODULE__{}

  # collector for indicators that determine feedback
  defstruct tendency: :neutral,
            last: "",
            strike: 0,
            # PID of process to display information
            presenter: 0,
            # past events to determine strikes etc
            event_history: [],
            # history of feedback
            feedback_history: [],
            timing: [],
            lastevent: "",
            lasttime: 0
end
