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
    cipher_bytes = cipher |> Matasano.decode16

    0..255 |>
    Enum.map(fn byte -> String.pad_leading(<<>>, byte_size(cipher_bytes), <<byte>>) end) |>
    Enum.map(fn guess -> Matasano.xor(cipher_bytes, guess) end) |>
    Enum.filter(&String.printable?/1) |>
    Enum.min_by(&Matasano.score/1)
  end
end
