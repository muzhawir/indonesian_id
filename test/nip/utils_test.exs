defmodule Nip.UtilsTest do
  use ExUnit.Case, async: true

  alias Nip.Utils

  doctest Nip.Utils

  describe "validate_length/1" do
    test "valid length" do
      assert Utils.validate_length("196711101992031001") === {:ok, "196711101992031001"}
    end

    test "invalid length" do
      assert Utils.validate_length("19671110199203100") === {:error, "Invalid length"}
    end
  end

  describe "get_birth_date/1" do
    test "valid birth date" do
      assert Utils.get_birth_date("196711101992031001") === {:ok, ~D[1967-11-10]}
    end

    test "invalid birth date" do
      assert Utils.get_birth_date("196713101992031001") === {:error, :invalid_date}
    end
  end

  describe "get_sex_code/1" do
    test "valid sex number code" do
      assert Utils.get_sex_code("196713101992031001") === {:ok, "M"}
    end

    test "invalid sex number code" do
      assert Utils.get_sex_code("196713101992035001") === {:error, "Invalid sex number code"}
    end
  end

  describe "get_serial_number/1" do
    test "valid serial number" do
      assert Utils.get_serial_number("196713101992031001") === {:ok, "001"}
    end

    test "serial number out of range" do
      assert Utils.get_serial_number("1967131019920319999") ===  {:error, "Serial number out of range"}
    end
  end
end
