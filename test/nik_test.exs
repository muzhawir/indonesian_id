defmodule NikTest do
  use ExUnit.Case, async: true

  doctest Nik

  describe "parse/1" do
    test "parse valid NIK" do
      result =
        {:ok,
         %Nik{
           id: "7210142507971234",
           area: %{
             city: %{"code" => "10", "name" => "Sigi", "type" => "Kabupaten"},
             district: %{"code" => "14", "name" => "Marawola", "type" => "Kecamatan"},
             province: %{"code" => "72", "name" => "Sulawesi Tengah"}
           },
           birth_date: ~D[1997-07-25],
           sex: "M",
           serial_number: "1234"
         }}

      assert Nik.parse("7210142507971234") === result
    end
  end
end
