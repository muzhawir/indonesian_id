defmodule Nik do
  @moduledoc """
  Functions for working with NIK (Nomor Induk Kependudukan)

  NIK consists of 16 digits that divided into 7 parts:
  - `2` digits for Province Code (`11-92`)
  - `2` digits for City Code (`01-99`)
  - `2` digits for Subdistrict Code (`01-99`)
  - `2` digits for Birth Day (`01-31`), if the person is female, the date will be added by `40`
  - `2` digits for Birth Month (`01-12`)
  - `2` digits for Birth Year (`YY`)
  - `4` digits for serial number (`0001-9999`) that is determined by system
  """

  alias Nik.Utils

  @type result() :: {:ok, t()} | {:error, String.t()}
  @type t :: %__MODULE__{
          id: String.t(),
          area: map(),
          birth_date: Date.t(),
          sex: String.t(),
          serial_number: String.t()
        }

  defstruct [
    :id,
    :area,
    :birth_date,
    :sex,
    :serial_number
  ]

  @doc """
  Parse NIK into a struct.

  Returns `{:ok, %Nik{}}` if the NIK is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nik.parse("7210142507971234")
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

  """
  @spec parse(String.t()) :: result()
  def parse(nik) when is_binary(nik) do
    with {:ok, _} <- Utils.validate_length(nik),
         {:ok, province} <- Utils.province_code(nik),
         {:ok, city} <- Utils.city_code(nik),
         {:ok, district} <- Utils.district_code(nik),
         {:ok, birth_date} <- Utils.birth_date(nik),
         {:ok, sex} <- Utils.sex_code(nik),
         {:ok, serial_number} <- Utils.serial_number(nik) do
      {:ok,
       %Nik{
         id: nik,
         area: %{
           province: province,
           city: city,
           district: district
         },
         birth_date: birth_date,
         sex: sex,
         serial_number: serial_number
       }}
    end
  end
end
