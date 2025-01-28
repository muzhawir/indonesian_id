defmodule Regional do
  @moduledoc """
  Functions for looking up regional codes based on Permendagri No. 72/2019.
  """
  @moduledoc since: "1.1.0"

  import Regional.Data
  import Regional.Utils

  @type regional_data() :: {:ok, map()} | {:error, String.t()}

  @doc """
  Find province by code.

  Returns `{:ok, %{province_data}}` if the province is found, otherwise
  `{:error, "Province data not found"}`.

  ## Examples

      iex> Regional.find_province(%{province_code: "72"})
      {:ok, %{"code" => "72", "name" => "Sulawesi Tengah"}}

  """
  @spec find_province(map()) :: regional_data()
  def find_province(%{province_code: province_code} = code) when is_map(code) do
    get_regional_data!() |> get_in([province_code]) |> search_code(:province)
  end

  @doc """
  Find city by province and city codes.

  Returns `{:ok, %{city_data}}` if the city is found, otherwise `{:error, "City data not found"}`.

  ## Examples

      iex> Regional.find_city(%{province_code: "72", city_code: "10"})
      {:ok, %{"code" => "10", "type" => "Kabupaten", "name" => "Sigi"}}

  """
  @spec find_city(map()) :: regional_data()
  def find_city(%{province_code: province_code, city_code: city_code} = code) when is_map(code) do
    get_regional_data!() |> get_in([province_code, "city", city_code]) |> search_code(:city)
  end

  @doc """
  Find district by province, city, and district codes.

  Returns `{:ok, %{district_data}}` if the district is found, otherwise
  `{:error, "District data not found"}`.

  ## Examples

      iex> Regional.find_district(%{province_code: "72", city_code: "10", district_code: "14"})
      {:ok, %{"code" => "14", "type" => "Kecamatan", "name" => "Marawola"}}

  """
  @spec find_district(map()) :: regional_data()
  def find_district(%{province_code: province_code, city_code: city_code, district_code: district_code} = code)
      when is_map(code) do
    get_regional_data!()
    |> get_in([province_code, "city", city_code, "district", district_code])
    |> search_code(:district)
  end

  @doc """
  Find subdistrict by province, city, district, and subdistrict codes.

  Returns `{:ok, %{subdistrict_data}}` if the subdistrict is found, otherwise
  `{:error, "Subdistrict data not found"}`.

  ## Examples

      iex> Regional.find_subdistrict(%{province_code: "72", city_code: "10", district_code: "14", subdistrict_code: "2007"})
      {:ok, %{"code" => "2007", "type" => "Desa", "name" => "Tinggede"}}

  """
  @spec find_subdistrict(map()) :: regional_data()
  def find_subdistrict(
        %{
          province_code: province_code,
          city_code: city_code,
          district_code: district_code,
          subdistrict_code: subdistrict_code
        } = code
      )
      when is_map(code) do
    get_regional_data!()
    |> get_in([province_code, "city", city_code, "district", district_code, "subdistrict", subdistrict_code])
    |> search_code(:subdistrict)
  end
end
