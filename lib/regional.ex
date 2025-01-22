defmodule Regional do
  @moduledoc """
  Functions for looking up regional codes based on Permendagri No. 72/2019.
  """

  import Regional.Data
  import Regional.Guard
  import Regional.Utils

  @type regional_code() :: {:ok, map()} | {:error, String.t()}

  @doc """
  Find province by code.

  Returns `{:ok, %{province_map}}` if the province is found, otherwise `{:error, "Data not found"}`.

  ## Examples

      iex> Regional.find_province("72")
      {:ok, %{"code" => "72", "name" => "Sulawesi Tengah"}}

  """
  @spec find_province(String.t()) :: regional_code()
  def find_province(province_code) when is_binary(province_code) do
    get_regional_data!()
    |> get_in([province_code])
    |> search_code(:province)
  end

  @doc """
  Find city by province and city codes.

  Returns `{:ok, %{city_map}}` if the city is found, otherwise `{:error, "Data not found"}`.

  ## Examples

      iex> Regional.find_city("72", "10")
      {:ok, %{"code" => "10", "type" => "Kabupaten", "name" => "Sigi"}}

  """
  @spec find_city(String.t(), String.t()) :: regional_code()
  def find_city(province_code, city_code) when is_valid_city_code(province_code, city_code) do
    get_regional_data!()
    |> get_in([province_code, "city", city_code])
    |> search_code(:city)
  end

  @doc """
  Find district by province, city, and district codes.

  Returns `{:ok, %{district_map}}` if the district is found, otherwise `{:error, "Data not found"}`.

  ## Examples

      iex> Regional.find_district("72", "10", "14")
      {:ok, %{"code" => "14", "type" => "Kecamatan", "name" => "Marawola"}}

  """
  @spec find_district(String.t(), String.t(), String.t()) :: regional_code()
  def find_district(province_code, city_code, district_code)
      when is_valid_district_code(province_code, city_code, district_code) do
    get_regional_data!()
    |> get_in([province_code, "city", city_code, "district", district_code])
    |> search_code(:district)
  end

  @doc """
  Find subdistrict by province, city, district, and subdistrict codes.

  Returns `{:ok, %{subdistrict_map}}` if the subdistrict is found, otherwise `{:error, "Data not found"}`.

  ## Examples

      iex> Regional.find_subdistrict("72", "10", "14", "2007")
      {:ok, %{"code" => "2007", "type" => "Desa", "name" => "Tinggede"}}

  """
  @spec find_subdistrict(String.t(), String.t(), String.t(), String.t()) :: regional_code()
  def find_subdistrict(province_code, city_code, district_code, subdistrict_code)
      when is_valid_subdistrict_code(province_code, city_code, district_code, subdistrict_code) do
    get_regional_data!()
    |> get_in([province_code, "city", city_code, "district", district_code, "subdistrict", subdistrict_code])
    |> search_code(:subdistrict)
  end
end
