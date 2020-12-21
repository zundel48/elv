defmodule Kaytest.Feedback.Helper do
  defmacro __using__(_) do
    quote do

      defp countplus([:positive | tail], i) do
        countplus(tail, i + 1)
      end

      defp countplus([:neutral | tail], i) do
        countplus(tail, i)
      end

      defp countplus([:negative | _tail], i) do
        i
      end

      defp countplus([], i) do
        i
      end

      def countplus(x) do
        countplus(x, 0)
      end

      defp countminus([:negative | tail], i) do
        countminus(tail, i + 1)
      end

      defp countminus([:neutral | tail], i) do
        countminus(tail, i)
      end

      defp countminus([:positive | _tail], i) do
        i
      end

      defp countminus([], i) do
        i
      end

      def countminus(x) do
        countminus(x, 0)
      end

    end
  end
end
