defmodule Regional.UtilsTest do
  use ExUnit.Case, async: true

  alias Regional.Utils

  describe "search_code/2" do
    test "returns error when data is nil" do
      assert Utils.search_code(nil, :province) == {:error, "Data not found"}
    end

    test "returns expected result when data is present" do
      data = %{"code" => "72", "name" => "Sulawesi Tengah"}
      expected_result = {:ok, %{"code" => "72", "name" => "Sulawesi Tengah"}}
      assert Utils.search_code(data, :province) == expected_result
    end
  end
end
