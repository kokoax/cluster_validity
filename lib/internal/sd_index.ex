defmodule Internal.SD_Index do
  require Archive
  def calc_validity(datasets) do
    v = datasets.data |> Enum.map(&(&1 |> Archive.variance))
    v_k = datasets |> cluster_variance
    s =
      v_k
      |> Enum.map(fn({data,_}) -> data |> Archive.norm end)
      |> Enum.sum
      |> Archive.frac(v_k |> Enum.count)
      |> Archive.frac(v |> Archive.norm)

    cent = each_centroid(datasets)
    d_data = cent |> get_d
    d_max  = d_data |> Enum.concat |> Enum.max
    d_min  = d_data |> Enum.concat |> Enum.min
    d_sum  = d_data |> Enum.map(&(1 / (&1 |> Enum.sum))) |> Enum.sum

    d = d_max/d_min * d_sum
    IO.puts s
    IO.puts d
    datasets.cluster_num*s + d
  end

  def get_d(cent) do
    0..(cent |> Enum.count)-1
    |> Enum.map(fn(i) ->
      0..(cent |> Enum.count)-1
      |> Enum.map(fn(j) ->
        if i != j do
          Archive.dist(
            cent |> Enum.at(i) |> Enum.at(0),
            cent |> Enum.at(j) |> Enum.at(0)
          )
        else
          nil
        end
      end)
    end)
    |> Enum.map(fn(item) -> item |> Enum.filter(&(&1 != nil)) end)
  end

  def each_centroid(datasets) do
    datasets.target_names
    |> Enum.uniq
    |> Enum.map(fn(tname) ->
      each_data =
        Enum.zip(datasets.data, datasets.target_all_name)
        |> Enum.filter(fn({_,n}) ->
          n == tname
        end)

        cent =
          each_data
          |> Enum.map(&(&1 |> elem(0)))
          |> Archive.centroid

          [cent, tname]
    end)
  end

  def cluster_variance(datasets) do
    datasets.target_names
    |> Enum.map(fn(name) ->
      cluster_var =
        Enum.zip(datasets.data, datasets.target_all_name)
        |> Enum.filter(fn({_,tname}) ->
          name == tname
        end)
        |> Enum.map(&(&1 |> elem(0) |> Archive.variance))
        {cluster_var, name}
    end)
  end
end

