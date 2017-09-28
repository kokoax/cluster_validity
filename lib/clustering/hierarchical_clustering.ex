defmodule HerarchicalClustering do
  require Archive
  def clustering(datasets, _k) do
    cluster = 0..datasets.amount-1 |> Enum.map(fn(i) -> i end)
    clustering_loop(datasets, cluster)
  end

  def clustering_loop(datasets, cluster) do
    old_cluster = cluster
    Process.put(:cluster, 0)
    each_cluster_data =
      0..(cluster |> Enum.max)
      |> Enum.map(fn(i) ->
        Enum.zip(datasets.data, cluster)
        |> Enum.filter(fn({_,c}) -> c == i end)
        |> Enum.map(fn({d,_}) -> d end)
      end)
    new_cluster = each_cluster_data
    |> Archive.second_map(fn(x1,x2) ->
      Archive.dist(x1 |> Enum.at(0),x2 |> Enum.at(0))
    end)
    |> IO.inspect
    |> Enum.map(fn(d) ->
      if d < 0.5 do
        Process.get(:cluster)
      else
        Process.get(:cluster, Process.get(:cluster)+1)
      end
    end)
    if new_cluster != old_cluster do
      clustering_loop(datasets, new_cluster)
    else
      new_cluster
    end
  end
end

