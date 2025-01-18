defmodule Nik.Utils do
  @moduledoc false

  @doc """
  Validate NIK length, must be 16 characters.

  Returns `{:ok, nik}` if the length is valid, otherwise `{:error, "Invalid length"}`.
  """
  @spec validate_length(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_length(nik) when is_binary(nik) do
    case String.length(nik) do
      16 -> {:ok, nik}
      _ -> {:error, "Invalid length"}
    end
  end

  @doc """
  Get province code from NIK.

  Returns `{:ok, %{province_map}}` if the province is found, otherwise `{:error, "Data not found"}`.
  """
  @spec province_code(String.t()) :: {:ok, map()} | {:error, String.t()}
  def province_code(nik) do
    province_code = String.slice(nik, 0..1)
    Regional.find_province(province_code)
  end

  @doc """
  Get city code from NIK.

  Returns `{:ok, %{city_map}}` if the city is found, otherwise `{:error, "Data not found"}`.
  """
  @spec city_code(String.t()) :: {:ok, map()} | {:error, String.t()}
  def city_code(nik) do
    province_code = String.slice(nik, 0..1)
    city_code = String.slice(nik, 2..3)
    Regional.find_city(province_code, city_code)
  end

  @doc """
  Get district code from NIK.

  Returns `{:ok, %{district_map}}` if the district is found, otherwise `{:error, "Data not found"}`.
  """
  @spec district_code(String.t()) :: {:ok, map()} | {:error, String.t()}
  def district_code(nik) do
    province_code = String.slice(nik, 0..1)
    city_code = String.slice(nik, 2..3)
    district_code = String.slice(nik, 4..5)
    Regional.find_district(province_code, city_code, district_code)
  end

  @doc """
  Get birth date from NIK.

  Returns `{:ok, date}` with date sigil at the second element if the date is valid,
  otherwise `{:error, reason}` from `Date.from_iso8601/1`.
  """
  @spec birth_date(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def birth_date(nik) do
    day = String.slice(nik, 6..7)
    month = String.slice(nik, 8..9)
    year = String.slice(nik, 10..11)
    normalized_day = normalize_day(day)
    normalized_year = normalize_year(year)
    Date.from_iso8601("#{normalized_year}-#{month}-#{normalized_day}")
  end

  # Normalize day number if the person is female, the date will be subtracted by `40`.
  defp normalize_day(day) do
    case String.to_integer(day) do
      number when number in 1..31 -> day
      number -> (number - 40) |> Integer.to_string() |> String.pad_leading(2, "0")
    end
  end

  # Because NIK represents the year with 2 digits. If the year is between 0 and 45,
  # it begins from year 2000; otherwise, it begins from year 1900.
  defp normalize_year(year) do
    case String.to_integer(year) do
      number when number in 0..45 -> Integer.to_string(number + 2000)
      number -> Integer.to_string(number + 1900)
    end
  end

  @doc """
  Get sex code from NIK.

  Returns `{:ok, "M" | "F"}` if the code is valid, otherwise `{:error, "Invalid birth day code"}`.
  """
  @spec sex_code(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def sex_code(nik) do
    birth_day = String.to_integer(String.slice(nik, 6..7))

    case birth_day do
      number when number in 1..31 -> {:ok, "M"}
      number when number in 41..71 -> {:ok, "F"}
      _ -> {:error, "Invalid birth day code"}
    end
  end

  @doc """
  Get serial number from NIK.

  Returns `{:ok, serial_number}` if the serial number in range 0-9999,
  otherwise `{:error, "Serial number out of range"}`.
  """
  @spec serial_number(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def serial_number(nik) do
    serial_number = String.slice(nik, 12..15)

    case String.to_integer(serial_number) do
      number when number in 0..9999 -> {:ok, serial_number}
      _ -> {:error, "Serial number out of range"}
    end
  end
end
