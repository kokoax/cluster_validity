defmodule ClusterValidityTest do
  use ExUnit.Case
  doctest ClusterValidity

  test "calc variance function in SD_Index" do
    assert 5.0 / 4 == Internal.SD_Index.variance([1,2,3,4])
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
