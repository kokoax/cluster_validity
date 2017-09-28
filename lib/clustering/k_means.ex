defmodule Clustering.K_Means do
  require Archive
  def clustering(datasets, k) do
    # initialize
    cluster  = new_cluster(datasets.amount, k)
    centroid = update_centroid(datasets, cluster, k)
    clustering_loop(datasets, cluster, centroid, k)
  end

  def new_cluster(amount, k) do
    0..amount-1
    |> Enum.map(fn(_) ->
      :rand.uniform(k)-1
    end)
  end

  def min_i(lst) do
    min = lst |> Enum.min
    0..(lst |> Enum.count)-1
    |> Enum.map(fn(i) ->
      if (lst |> Enum.at(i)) == min do
        i
      else
        nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.at(0)
  end

  def update_cluster(datasets, centroid) do
    datasets.data
    |> Enum.map(fn(feature) ->
      centroid
      |> Enum.map(fn(cent) ->
        Archive.dist(cent, feature)
      end)
      |> min_i
    end)
  end

  def update_centroid(datasets, cluster, k) do
    0..k-1
    |> Enum.map(fn(i) ->
      Enum.zip(datasets.data, cluster)
      |> Enum.filter(fn({_,c}) -> c == i end)
      |> Enum.map(fn({d,_}) -> d end)
      |> Archive.centroid
    end)
  end

  def clustering_loop(datasets, cluster, centroid, k) do
    updated_cluster = update_cluster(datasets, centroid)
    updated_centroid = update_centroid(datasets, updated_cluster, k)
    if centroid != updated_centroid do
      clustering_loop(datasets, updated_cluster, updated_centroid, k)
    else
      {cluster, centroid}
    end
  end
end

