defmodule Nik.Utils do
  @moduledoc false

  @spec validate_length(String.t()) :: {:ok | :error, String.t()}
  def validate_length(nik) when is_binary(nik) do
    if String.length(nik) === 16 do
      {:ok, nik}
    else
      {:error, "Invalid length"}
    end
  end

  @spec area_code(String.t()) :: map()
  def area_code(nik) do
    %{
      province: province_code(nik),
      city: city_code(nik),
      subdistrict: subdistrict_code(nik)
    }
  end

  defp province_code(nik) do
    _provice_code = String.slice(nik, 0..1)

    %{code: "72", name: "Sulawesi Tengah"}
  end

  defp city_code(nik) do
    _province_code = province_code(nik)
    _city_code = String.slice(nik, 2..3)

    %{code: "10", name: "Sigi"}
  end

  defp subdistrict_code(nik) do
    _provice_code = province_code(nik)
    _city_code = city_code(nik)
    _subdistrict_code = String.slice(nik, 4..5)

    %{code: "14", name: "Marawola"}
  end

  @spec birth_date(String.t()) :: {:ok | :error, Date.t()}
  def birth_date(nik) do
    day = String.slice(nik, 6..7)
    month = String.slice(nik, 8..9)
    year = String.slice(nik, 10..11)
    normalized_day = normalize_day(day)
    normalized_year = normalize_year(year)

    Date.from_iso8601("#{normalized_year}-#{month}-#{normalized_day}")
  end

  defp normalize_day(day) do
    if String.to_integer(day) in 1..31 do
      day
    else
      (String.to_integer(day) - 40) |> Integer.to_string() |> String.pad_leading(2, "0")
    end
  end

  defp normalize_year(year) do
    if String.to_integer(year) in 0..45 do
      Integer.to_string(String.to_integer(year) + 2000)
    else
      Integer.to_string(String.to_integer(year) + 1900)
    end
  end

  @spec sex_code(String.t()) :: {:ok | :error, String.t()}
  def sex_code(nik) do
    birth_day = nik |> String.slice(6..7) |> String.to_integer()

    cond do
      birth_day in 1..31 -> {:ok, "M"}
      birth_day in 41..71 -> {:ok, "F"}
      true -> {:error, "Invalid birth day code"}
    end
  end

  def serial_number(nik) do
    serial_number = String.slice(nik, 12..15)

    if String.to_integer(serial_number) in 0..9999 do
      {:ok, serial_number}
    else
      {:error, "Serial number out of range"}
    end
  end
end
