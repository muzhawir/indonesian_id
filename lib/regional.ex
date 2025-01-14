defmodule Regional do
  @moduledoc """
  Functions for lookup regional code based on Permendagri No. 72/2019
  """

  @spec province(String.t()) :: {:ok | :error, map()}
  def province(code) when is_binary(code) do
    {:ok, %{code: "72", name: "Sulawesi Tengah"}}
  end

  defguard is_valid_city_code(province_code, city_code)
           when is_binary(province_code) and is_binary(city_code)

  def city(province_code, city_code) when is_valid_city_code(province_code, city_code) do
    {:ok, %{code: "10", type: "Kota", name: "Sigi"}}
  end

  defguard is_valid_subdistrict_code(province_code, city_code, subdistrict_code)
           when is_binary(province_code) and is_binary(city_code) and is_binary(subdistrict_code)

  def subdistrict(province_code, city_code, subdistrict_code)
      when is_valid_subdistrict_code(province_code, city_code, subdistrict_code) do
    {:ok, %{code: "14", type: "Kelurahan", name: "Marawola"}}
  end
end
