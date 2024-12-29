defmodule Nip.UtilsTest do
  use ExUnit.Case, async: true

  alias Nip.Utils

  doctest Nip.Utils

  describe "validate_length/1" do
    test "valid length" do
      assert Utils.validate_length("200012312024121001") === {:ok, "200012312024121001"}
    end

    test "invalid length" do
      assert Utils.validate_length("20001231202412100") === {:error, "Invalid length"}
    end
  end

  describe "get_birth_date/1" do
    test "valid birth date" do
      assert Utils.get_birth_date("200012312024121001") === {:ok, ~D[2000-12-31]}
    end

    test "invalid birth date" do
      assert Utils.get_birth_date("200013312024121001") === {:error, :invalid_date}
    end
  end

  describe "get_sex_code/1" do
    test "valid sex number code" do
      assert Utils.get_sex_code("200012312024121001") === {:ok, "M"}
    end

    test "invalid sex number code" do
      assert Utils.get_sex_code("200012312024123001") === {:error, "Invalid sex number code"}
    end
  end

  describe "get_serial_number/1" do
    test "valid serial number" do
      assert Utils.get_serial_number("200012312024121001") === {:ok, "001"}
    end

    test "serial number out of range" do
      assert Utils.get_serial_number("2000123120241219999") === {:error, "Serial number out of range"}
    end
  end
end
