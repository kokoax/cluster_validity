defmodule Clustering.KNN do
  require Archive
  def clustering({datasets, data}) do
    Enum.zip(datasets.data, datasets.target_all_name)
    |> Enum.map(fn({each_data,name}) ->
      # IO.inspect data
      [Archive.dist(each_data, data), name]
    end)
    |> Enum.sort
    |> vote(3,datasets.target_names)
  end

  defp vote(sorted, k, target_names) do
    vote_names = 0..k-1
                 |> Enum.map(&(sorted |> Enum.at(&1) |> Enum.at(1)))
                 # |> Enum.map(&(counter = counter |> Map.update(&1,1,fn x -> x+1 end)))
    target_names
    |> Enum.map(
      fn(tname) ->
        {
          (vote_names
          |> Enum.filter(&(&1 == tname))
          |> Enum.count), tname
        }
      end)
      |> Enum.max_by(fn({count,_}) -> count end) # TODO: More check detaily
  end
end

