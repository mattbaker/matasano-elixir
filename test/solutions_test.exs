defmodule SolutionsTest do
  use ExUnit.Case
  doctest Solutions

  test "set 1 challenge 1" do
    encoded = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    assert Solutions.set_1_challenge_1(encoded) == expected
  end

  test "set 1 challenge 2" do
    encoded = "1c0111001f010100061a024b53535009181c"
    xor_with = "686974207468652062756c6c277320657965"
    expected = "746865206b696420646f6e277420706c6179"
    assert Solutions.set_1_challenge_2(encoded, xor_with) == expected
  end

  test "set 1 challenge 3" do
    enciphered = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
    deciphered = "Cooking MC's like a pound of bacon"
    assert Solutions.set_1_challenge_3(enciphered) == deciphered
  end

  test "set 1 challenge 4" do
    file = "ciphers.txt"
    deciphered = "Now that the party is jumping"
    assert Solutions.set_1_challenge_4(file) == deciphered
  end

  test "set 1 challenge 5" do
    plaintext = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    enciphered = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
    assert Solutions.set_1_challenge_5(plaintext) == enciphered
  end
end
