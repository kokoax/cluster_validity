defmodule Internal.SilhouetteIndex do
  require Archive
  def calc_validity(datasets) do
    0..datasets.cluster_num-1
    |> Enum.map(fn(cluster) ->
      datasets |> s_dash(cluster)
    end)
    |> Enum.sum
    |> Archive.frac(datasets.cluster_num)
  end

  def cluster_dist(datasets, data_i, k) do
    Enum.zip(datasets.data, datasets.target_all_name)
    |> Enum.filter(fn({_,c}) ->
      c == datasets.target_names |> Enum.at(k)
    end)
    |> Enum.map(fn({d,_}) ->
      Archive.dist(d, data_i)
    end)
    |> Enum.sum
  end

  def a(datasets, data_i, k) do
    cluster_dist(datasets, data_i, k)
    |> Archive.frac(datasets.each_amount |> Enum.at(k))
  end

  def rho(datasets, data_i, k) do
    0..datasets.cluster_num-1
    |> Enum.map(fn(i) ->
      if i != k do
        cluster_dist(datasets, data_i, i)
        |> Archive.frac(datasets.each_amount |> Enum.at(i))
      else
        :infinity
      end
    end)
  end

  def b(datasets, data_i, k) do
    rho(datasets, data_i, k) |> Enum.min
  end

  def s(datasets, data_i, k) do
    v_a = a(datasets, data_i, k)
    v_b = b(datasets, data_i, k)
    Archive.frac(v_b-v_a,
         [v_a, v_b] |> Enum.max)
  end

  def s_dash(datasets, k) do
    Enum.zip(datasets.data, datasets.target_all_name)
    # 指定のクラスタのデータを抽出
    |> Enum.filter(fn({_,cluster_i}) ->
      cluster_i == datasets.target_names |> Enum.at(k)
    end)
    # 指定のクラスタのデータ全部に対してs()を実行
    |> Enum.map(fn({data_i,_}) ->
      s(datasets, data_i, k)
    end)
    # meanを取得
    |> Enum.sum
    |> Archive.frac(datasets.each_amount |> Enum.at(k))
    |> IO.inspect
  end
end

