defmodule Matasano do
  use Bitwise

  def decode16(encoded) do
    {:ok, value} = encoded |>
    Base.decode16(case: :lower)
    value
  end

  def xor(bin1, bin2, xored \\ <<>>)
  def xor(<<>>, <<>>, xored), do: xored
  def xor(<<byte1, bin1::binary>>, <<byte2, bin2::binary>>, xored) do
    xor(bin1, bin2, xored <> <<byte1 ^^^ byte2>>)
  end

  def score(cipher_str) do
    baseline = %{
      "e" =>	12.702, "t" =>	9.056, "a" =>	8.167,
      "o" =>	7.507, "i" =>	6.966, "n" =>	6.749,
      "s" =>	6.327, "h" =>	6.094, "r" =>	5.987,
      "d" =>	4.253, "l" =>	4.025, "c" =>	2.782,
      "u" =>	2.758, "m" =>	2.406, "w" =>	2.360,
      "f" =>	2.228, "g" =>	2.015, "y" =>	1.974,
      "p" =>	1.929
    }
    cipher_len = String.length(cipher_str)

    is_letter = fn(char) -> char =~ ~r/[a-z]/ end
    increase_entry_count = fn(letter, acc) -> Map.update(acc, letter, 1, &(&1 + 1)) end
    put_frequency = fn({letter, count}, freqs) -> Map.put(freqs, letter, count / cipher_len) end

    cipher_freqs = cipher_str |>
      String.graphemes |>
      Enum.map(&String.downcase/1) |>
      Enum.filter(is_letter) |>
      Enum.reduce(%{}, increase_entry_count) |>
      Enum.reduce(%{}, put_frequency)

    baseline |> Enum.reduce(0, fn({letter, freq}, score) ->
      score + freq - Map.get(cipher_freqs, letter, 0) end)
  end

  def brute_xor(cipher_str) do
    guesses = 0..255 |>
      Enum.map(fn byte -> String.pad_leading(<<>>, byte_size(cipher_str), <<byte>>) end) |>
      Enum.map(fn guess -> Matasano.xor(cipher_str, guess) end) |>
      Enum.filter(&String.printable?/1)

    if !Enum.empty?(guesses) do
      best_guess = guesses |>
        Enum.map(fn guess -> {guess, Matasano.score(guess)} end) |>
        Enum.min_by(&elem(&1, 1))
      {:ok, best_guess}
    else
      {:error, :empty}
    end
  end
end
