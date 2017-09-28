defmodule External.JaccardIndex do
  def calc_validity(clustered, original) do
    same =
      Enum.zip(clustered, original)
      |> Enum.filter(fn({c,o}) ->
        c == o
      end) |> Enum.count
    all = original |> Enum.count
    same / all
  end
end

