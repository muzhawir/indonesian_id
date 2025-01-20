defmodule Regional.Guard do
  @moduledoc false

  defguard is_valid_city_code(province_code, city_code)
           when is_binary(province_code) and is_binary(city_code)

  defguard is_valid_district_code(province_code, city_code, district_code)
           when is_binary(province_code) and
                  is_binary(city_code) and
                  is_binary(district_code)

  defguard is_valid_subdistrict_code(province_code, city_code, district_code, subdistrict_code)
           when is_binary(province_code) and
                  is_binary(city_code) and
                  is_binary(district_code) and
                  is_binary(subdistrict_code)
end
