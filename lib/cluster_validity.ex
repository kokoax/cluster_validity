defmodule ClusterValidity do
  alias Clustering.KNN
  alias Clustering.K_Means
  alias External.JaccardIndex
  alias Internal.SD_Index

  def get_results(datasets) do
    0..datasets.amount-1
    |> Enum.map(fn(i) ->
      {datasets, datasets.data |> Enum.at(i)} |> KNN.clustering
    end)
    |> Enum.map(fn({_count,name}) -> name end)
  end

  def parse_internal(datasets, k) do
    {new_cluster,_} = datasets
    |> K_Means.clustering(k)
    each_amount =
      new_cluster
      |> Enum.map(fn(c) ->
        new_cluster
        |> Enum.filter(fn(n_c) ->
          c == n_c
        end)
        |> Enum.count
      end)
    %UCIDataLoader {
      data:            datasets.data,
      target_all_name: new_cluster,
      target_names:    new_cluster |> Enum.uniq,
      length:          4,
      amount:          150,
      cluster_num:     new_cluster |> Enum.uniq |> Enum.count,
      each_amount:     each_amount,
    }
  end

  defmacro internal(module, datasets, k) do
    quote do
      unquote(datasets)
      |> ClusterValidity.parse_internal(unquote(k))
      |> unquote(module).calc_validity()
    end
  end

  defmacro external(module, datasets) do
    quote do
      unquote(datasets)
      |> ClusterValidity.get_results
      |> unquote(module).calc_validity(unquote(datasets).target_all_name)
    end
  end

  def main(datasets) do
    datasets |> IO.inspect
    # |> JaccardIndex.calc_validity(datasets.target_all_name)
  end
end

