defmodule Regional.Utils do
  @moduledoc false

  @type regional_data() :: map() | nil
  @type regional_result() :: {:error, String.t()} | {:ok, map()}

  @doc """
  Searches regional data based on a series of code structures.

  Returns `{:ok, data}` if the data is found; otherwise, returns an error with a specific message.
  Returns `{:ok, data}` if the data is found; otherwise, returns `{:error, "Data not found"}`.
  """
  @spec search_code(regional_data(), atom()) :: regional_result()
  def search_code(nil, type), do: {:error, error_message(type)}
  def search_code(data, type), do: {:ok, extract_data(data, type)}

  defp extract_data(data, type) do
    case type do
      :province -> Map.take(data, ["code", "name"])
      :city -> Map.take(data, ["code", "type", "name"])
      :district -> Map.take(data, ["code", "type", "name"])
      :subdistrict -> Map.take(data, ["code", "type", "name"])
    end
  end

  defp error_message(:province), do: "Province data not found"
  defp error_message(:city), do: "City data not found"
  defp error_message(:district), do: "District data not found"
  defp error_message(:subdistrict), do: "Subdistrict data not found"
end
