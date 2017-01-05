defmodule Solutions do

  def set_1_challenge_1(encoded) do
    encoded |>
      Matasano.decode16 |>
      Base.encode64
  end

  def set_1_challenge_2(encoded, xor_with) do
    Matasano.xor(Matasano.decode16(encoded), Matasano.decode16(xor_with)) |>
      Base.encode16(case: :lower)
  end

  def set_1_challenge_3(cipher) do
    cipher |>
      Matasano.decode16 |>
      Matasano.brute_xor |>
      elem(0)
  end

  def set_1_challenge_4(file) do
    file |>
      File.read |>
      extract_ok_value |>
      String.split("\n") |>
      Enum.map(&Matasano.decode16/1) |>
      Enum.map(&Matasano.brute_xor/1) |>
      Enum.min_by(fn {_, score} -> score end) |>
      elem(0) |>
      String.rstrip
  end

  def set_1_challenge_5(plaintext) do
    plaintext |>
      Matasano.xor_encrypt("ICE") |>
      Base.encode16(case: :lower)
  end

  defp extract_ok_value({:ok, value}), do: value
end
