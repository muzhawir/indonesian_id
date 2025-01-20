defmodule RegionalTest do
  use ExUnit.Case, async: true

  doctest Regional

  describe "find_province/1" do
    test "returns expected result when data is present" do
      expected_result = {:ok, %{"code" => "72", "name" => "Sulawesi Tengah"}}
      assert Regional.find_province("72") == expected_result
    end

    test "returns error when data is not present" do
      assert Regional.find_province("2025") == {:error, "Data not found"}
    end
  end

  describe "find_city/2" do
    test "returns expected result when data is present" do
      expected_result = {:ok, %{"code" => "10", "name" => "Sigi", "type" => "Kabupaten"}}
      assert Regional.find_city("72", "10") == expected_result
    end

    test "returns error when data is not present" do
      assert Regional.find_province("2025") == {:error, "Data not found"}
    end
  end

  describe "find_district/3" do
    test "returns expected result when data is present" do
      expected_result = {:ok, %{"code" => "14", "name" => "Marawola", "type" => "Kecamatan"}}
      assert Regional.find_district("72", "10", "14") == expected_result
    end

    test "returns error when data is not present" do
      assert Regional.find_province("2025") == {:error, "Data not found"}
    end
  end

  describe "find_subdistrict/4" do
    test "returns expected result when data is present" do
      expected_result = {:ok, %{"code" => "2007", "name" => "Tinggede", "type" => "Desa"}}
      assert Regional.find_subdistrict("72", "10", "14", "2007") == expected_result
    end

    test "returns error when data is not present" do
      assert Regional.find_province("2025") == {:error, "Data not found"}
    end
  end
end
