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
           birth_date: "2000-12-31",
           tmt_date: "2024-01-01",
           frequency: "1",
           sex: "M",
           serial_number: "001"
         }}

      assert Pppk.parse("200012312024211001") === result
    end

    test "parses invalid NIP" do
      refute Pppk.parse("200012312024211001") === {:error, "Invalid length"}
    end
  end

  describe "get_tmt/1" do
    test "valid TMT date" do
      assert Pppk.get_tmt("200012312024211001") === {:ok, ~D[2024-01-01]}
    end

    test "invalid TMT date" do
      refute Pppk.get_tmt("200012312024211001") === {:error, :invalid_format}
    end
  end

  describe "get_frequency/1" do
    test "valid frequency number" do
      assert Pppk.get_frequency("200012312024211001") === {:ok, "1"}
    end

    test "frequency out of range" do
      refute Pppk.get_frequency("200012312024211001") === {:error, "frequency out of range"}
    end
  end

  describe "validate_format/1" do
    test "valid NIP" do
      assert Pppk.validate_format("200012312024211001") === {:ok, "200012312024211001"}
    end

    test "invalid NIP" do
      refute Pppk.validate_format("200012312024211001") === {:error, "Invalid length"}
    end
  end
end
