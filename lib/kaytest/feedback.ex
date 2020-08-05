defmodule Kaytest.Feedback do
  def points do
    Enum.random(1000..2000)
  end

  def difficulty do
    Enum.random(20..45)
  end

  def progress do
    Enum.random(1..55)
  end

end
