defmodule NikTest do
  use ExUnit.Case, async: true

  doctest Nik

  describe "parse/1" do
    test "parse valid NIK" do
      result =
        %Nik{
          id: "7210142507971234",
          area: %{
            province: %{code: "72", name: "Sulawesi Tengah"},
            city: %{code: "10", name: "Sigi"},
            subdistrict: %{code: "14", name: "Marawola"}
          },
          birth_date: ~D[1997-07-25],
          sex: "M",
          serial_number: "1234"
        }

      assert Nik.parse("7210142507971234") === result
    end
  end
end
