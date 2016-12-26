defmodule Solutions do
  def set_1_challenge_1(encoded) do
    encoded |>
    Matasano.decode16 |>
    Base.encode64
  end

  def set_1_challenge_2(encoded, xor_with) do
    Matasano.xor(
      Matasano.decode16(encoded),
      Matasano.decode16(xor_with)) |>
    Base.encode16(case: :lower)
  end

  def set_1_challenge_3(cipher) do
    {:ok, {deciphered_guess, _}} = cipher |>
      Matasano.decode16 |>
      Matasano.brute_xor
    deciphered_guess
  end

  def set_1_challenge_4(file) do
    {:ok, contents} = File.read(file)

    {:ok, {deciphered, _}} = contents |>
      String.split("\n") |>
      Enum.map(&Matasano.decode16/1) |>
      Enum.map(&Matasano.brute_xor/1) |>
      Enum.filter(&match?({:ok, _}, &1)) |>
      Enum.min_by(fn {:ok, {_, score}} -> score end)

    String.rstrip(deciphered)
  end
end
