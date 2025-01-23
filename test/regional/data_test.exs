defmodule Regional.DataTest do
  use ExUnit.Case, async: true

  describe "regional_data!/0" do
    test "returns the decoded JSON data" do
      assert is_map(Regional.Data.get_regional_data!())
    end
  end
end
