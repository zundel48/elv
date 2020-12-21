defmodule Kaytest.Feedback.State do
  @type t :: %__MODULE__{}

  # implemented as a gensever
  # PID of process to display information
  defstruct presenter: 0,
            # past events to determine strikes etc
            event_history: [],
            # history of feedback
            feedback_history: [],
            timing: [],
            lasttime: 0,
            analyse: []

end
