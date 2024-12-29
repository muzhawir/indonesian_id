defmodule Nip.PnsTest do
  use ExUnit.Case, async: true

  alias Nip.Pns

  doctest Nip.Pns

  describe "parse/1" do
    test "parses valid NIP" do
      result =
        {:ok,
         %Pns{
           nip: "196711101992031001",
           birth_date: "1967-11-10",
           tmt_date: "1992-03-01",
           sex: "M",
           serial_number: "001"
         }}

      assert Pns.parse("196711101992031001") === result
    end

    test "parses invalid NIP" do
      assert Pns.parse("19671110199203100") === {:error, "Invalid length"}
    end
  end

  describe "validate_format/1" do
    test "valid NIP" do
      assert Pns.validate_format("196711101992031001") === {:ok, "196711101992031001"}
    end

    test "invalid NIP" do
      assert Pns.validate_format("19671110199203100") === {:error, "Invalid length"}
    end
  end
end
