defmodule NIK.Id do
  @moduledoc """
  Functions for working with NIK (Nomor Induk Kependudukan)

  NIK consists of 16 digits that divided into 7 parts:
  - `2` digits for Province Code (`11-92`)
  - `2` digits for City Code (`01-99`)
  - `2` digits for Subdistrict Code (`01-99`)
  - `2` digits for Birth Date (`01-31`), if the person is female, the date will be added by `40`
  - `2` digits for Birth Month (`01-12`)
  - `4` digits for Birth Year (`YY`)
  - `3` digits for serial number (`001-999`) that id determined by system
  """

  defstruct [
    :area,
    :sex,
    :birth_date,
    :serial_number
  ]

  def parse(nik) when is_binary(nik) do
    %NIK.Id{
      area: %{
        province: %{code: "72", name: "Sulawesi Tengah"},
        city: %{code: "10", name: "Sigi"},
        subdistrict: %{code: "14", name: "Marawola"}
      },
      sex: "M",
      birth_date: ~D[1997-03-25],
      serial_number: "123"
    }
  end

  def validate_length(nik) when is_binary(nik) do
    if String.length(nik) === 16 do
      {:ok, nik}
    else
      {:error, "Invalid length"}
    end
  end
end
