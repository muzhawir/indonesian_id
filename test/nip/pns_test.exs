defmodule Nip.PnsTest do
  use ExUnit.Case, async: true

  alias Nip.Pns

  doctest Nip.Pns

  describe "parse/1" do
    test "parses valid NIP" do
      result =
        {:ok,
         %Pns{
           nip: "200012312024121001",
           birth_date: "2000-12-31",
           tmt_date: "2024-12-01",
           sex: "M",
           serial_number: "001"
         }}

      assert Pns.parse("200012312024121001") === result
    end

    test "parses invalid NIP" do
      assert Pns.parse("20001231202412100") === {:error, "Invalid length"}
    end
  end

  describe "validate_format/1" do
    test "valid NIP" do
      assert Pns.validate_format("200012312024121001") === {:ok, "200012312024121001"}
    end

    test "invalid NIP" do
      assert Pns.validate_format("20001231202412100") === {:error, "Invalid length"}
    end
  end
end
