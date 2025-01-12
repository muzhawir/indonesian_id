defmodule NIK.IdTest do
  use ExUnit.Case, async: true

  alias NIK.Id

  doctest NIK.Id

  describe "validate_length/1" do
    test "valid NIK" do
      assert Id.validate_length("7210142507971234") === {:ok, "7210142507971234"}
    end

    test "invalid NIK" do
      assert Id.validate_length("721014250797123") === {:error, "Invalid length"}
    end
  end
end
