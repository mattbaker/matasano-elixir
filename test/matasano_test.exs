defmodule MatasanoTest do
  use ExUnit.Case
  doctest Matasano

  test "xor" do
    bin1 = <<0, 0, 1, 0, 1>>
    bin2 = <<1, 1, 1, 1, 1>>
    expected = <<1, 1, 0, 1, 0>>
    assert Matasano.xor(bin1, bin2) == expected
  end

  # test "score":
  #  see solutions_test.exs for integration test
  #  in set 1 challenge 3
end
