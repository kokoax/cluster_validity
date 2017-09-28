defmodule Archive do
  def frac(x, y) do
    x / y
  end

  def dist(vec1, vec2) do
    Enum.zip(vec1, vec2)
    |> Enum.map(fn({v1,v2}) ->
      (v1-v2) |> :math.pow(2)
    end)
    |> Enum.sum
    |> :math.sqrt
  end

  def norm(vec) do
    vec
    |> Enum.map(&(&1 |> :math.pow(2)))
    |> Enum.sum
    |> :math.sqrt
  end

  def centroid(data) do
    len = data |> Enum.at(0) |> Enum.count
    0..len-1
    |> Enum.map(fn(i) ->
      data
      |> Enum.map(&(&1 |> Enum.at(i)))
      |> Enum.sum
      |> frac(data |> Enum.count)
    end)
  end

  def mean(vec) do
    vec
    |> Enum.sum
    |> frac(vec |> Enum.count)
  end

  def variance(vec) do
    mean =
      vec
      |> Enum.sum
      |> frac(vec |> Enum.count)
    vec
    |> Enum.map(&((&1-mean) |> :math.pow(2)))
    |> Enum.sum
    |> frac(vec |> Enum.count)
  end

  defmacro two_map(list, func) do
    quote do
      times = round(Enum.count(unquote(list))/2)-1
      for i <- 0..times do
        unquote(func).(
          Enum.at(unquote(list),i*2),
          Enum.at(unquote(list),i*2+1)
        )
      end
    end
  end
  defmacro second_map(list, func) do
    quote do
      times = round(Enum.count(unquote(list)))-2
      for i <- 0..times do
        unquote(func).(
          Enum.at(unquote(list),i),
          Enum.at(unquote(list),i+1)
        )
      end
    end
  end
end

