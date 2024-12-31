defmodule Nip.PnsTest do
  use ExUnit.Case, async: true

  alias Nip.Pns

  doctest Nip.Pns

  describe "parse/1" do
    test "parse valid NIP" do
      result =
        {:ok,
         %Nip.Pns{
           nip: "200012312024121001",
           birth_date: ~D[2000-12-31],
           tmt_date: ~D[2024-12-01],
           sex: "M",
           serial_number: "001"
         }}

      assert Pns.parse("200012312024121001") === result
    end

    test "parse invalid NIP" do
      assert Pns.parse("20001231202412100") === {:error, "Invalid length"}
      assert Pns.parse("200013312024121001") === {:error, :invalid_date}
      assert Pns.parse("200012312024123001") === {:error, "Invalid sex number code"}
    end
  end

  describe "validate_format/1" do
    test "valid NIP" do
      assert Pns.validate_format("200012312024121001") === {:ok, "200012312024121001"}
    end

    test "invalid NIP" do
      assert Pns.validate_format("20001231202412100") === {:error, "Invalid length"}
      assert Pns.validate_format("200013312024121001") === {:error, :invalid_date}
      assert Pns.validate_format("200012312024123001") === {:error, "Invalid sex number code"}
    end
  end
end
