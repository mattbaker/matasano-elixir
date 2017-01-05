defmodule Matasano do
  use Bitwise

  def decode16(encoded) do
    {:ok, value} = Base.decode16(encoded, case: :lower)
    value
  end

  def xor(bin1, bin2, xored_bytes \\ <<>>)
  def xor(<<>>, <<>>, xored_bytes), do: xored_bytes
  def xor(<<byte1, bin1::binary>>, <<byte2, bin2::binary>>, xored_bytes) do
    xor(bin1, bin2, xored_bytes <> <<byte1 ^^^ byte2>>)
  end

  def xor_with_key(plaintext, key) do
    xor_str = String.pad_leading(<<>>, byte_size(plaintext), key)
    xor(plaintext, xor_str)
  end

  def brute_xor(cipher_str) do
    0..255 |>
      Enum.map(&Matasano.xor_with_key(cipher_str, <<&1>>)) |>
      Enum.filter(&String.printable?/1) |>
      Enum.map(fn guess -> {guess, Matasano.score(guess)} end) |>
      Enum.min_by(&elem(&1, 1), fn -> {"", 100} end)
  end

  def score(cipher_str) do
    baseline_frequencies = %{
      "e" =>	12.702, "t" =>	9.056, "a" =>	8.167,
      "o" =>	7.507, "i" =>	6.966, "n" =>	6.749,
      "s" =>	6.327, "h" =>	6.094, "r" =>	5.987,
      "d" =>	4.253, "l" =>	4.025, "c" =>	2.782,
      "u" =>	2.758, "m" =>	2.406, "w" =>	2.360,
      "f" =>	2.228, "g" =>	2.015, "y" =>	1.974,
      "p" =>	1.929}

    cipher_len = String.length(cipher_str)

    letter_counts = cipher_str |>
      String.graphemes |>
      Enum.map(&String.downcase/1) |>
      Enum.reduce(%{}, &increment_map_entry/2)

    Enum.reduce(baseline_frequencies, 0,
      fn({letter, standard_freq}, score) ->
        cipher_freq = Map.get(letter_counts, letter, 0) / cipher_len
        score + standard_freq - cipher_freq
      end
    )
  end

  defp increment_map_entry(key, map) do
    Map.update(map, key, 1, &(&1 + 1))
  end
end
