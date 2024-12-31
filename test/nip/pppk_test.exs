defmodule Nip.PppkTest do
  use ExUnit.Case, async: true

  alias Nip.Pppk

  doctest Nip.Pppk

  describe "parse/1" do
    test "parses valid NIP" do
      result =
        {:ok,
         %Nip.Pppk{
           nip: "200012312024211001",
           birth_date: ~D[2000-12-31],
           tmt_date: ~D[2024-01-01],
           frequency: 1,
           sex: "M",
           serial_number: "001"
         }}

      assert Pppk.parse("200012312024211001") === result
    end

    test "parses invalid NIP" do
      assert Pppk.parse("20001231202421100") === {:error, "Invalid length"}
      assert Pppk.parse("200013312024211001") === {:error, :invalid_date}
      assert Pppk.parse("200012312024213001") === {:error, "Invalid sex number code"}
    end
  end

  describe "validate_format/1" do
    test "valid NIP" do
      assert Pppk.validate_format("200012312024211001") === {:ok, "200012312024211001"}
    end

    test "invalid NIP" do
      assert Pppk.validate_format("20001231202421100") === {:error, "Invalid length"}
      assert Pppk.validate_format("200013312024211001") === {:error, :invalid_date}
      assert Pppk.validate_format("200012312024213001") === {:error, "Invalid sex number code"}
    end
  end
end
