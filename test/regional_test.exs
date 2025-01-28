defmodule RegionalTest do
  use ExUnit.Case, async: true

  doctest Regional

  describe "find_province/1" do
    test "returns expected result when data is present" do
      input = %{province_code: "72"}
      expected_result = {:ok, %{"code" => "72", "name" => "Sulawesi Tengah"}}

      assert Regional.find_province(input) == expected_result
    end

    test "returns error when data is not present" do
      input = %{province_code: "2025"}

      assert Regional.find_province(input) == {:error, "Province data not found"}
    end
  end

  describe "find_city/2" do
    test "returns expected result when data is present" do
      input = %{province_code: "72", city_code: "10"}
      expected_result = {:ok, %{"code" => "10", "name" => "Sigi", "type" => "Kabupaten"}}

      assert Regional.find_city(input) == expected_result
    end

    test "returns error when data is not present" do
      input = %{province_code: "72", city_code: "1000"}

      assert Regional.find_city(input) == {:error, "City data not found"}
    end
  end

  describe "find_district/3" do
    test "returns expected result when data is present" do
      input = %{province_code: "72", city_code: "10", district_code: "14"}
      expected_result = {:ok, %{"code" => "14", "name" => "Marawola", "type" => "Kecamatan"}}

      assert Regional.find_district(input) == expected_result
    end

    test "returns error when data is not present" do
      input = %{province_code: "72", city_code: "10", district_code: "1400"}

      assert Regional.find_district(input) == {:error, "District data not found"}
    end
  end

  describe "find_subdistrict/4" do
    test "returns expected result when data is present" do
      input = %{province_code: "72", city_code: "10", district_code: "14", subdistrict_code: "2007"}
      expected_result = {:ok, %{"code" => "2007", "name" => "Tinggede", "type" => "Desa"}}

      assert Regional.find_subdistrict(input) == expected_result
    end

    test "returns error when data is not present" do
      input = %{province_code: "72", city_code: "10", district_code: "14", subdistrict_code: "20070"}

      assert Regional.find_subdistrict(input) == {:error, "Subdistrict data not found"}
    end
  end
end
