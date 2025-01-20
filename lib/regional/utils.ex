defmodule Regional.Utils do
  @moduledoc false

  @type data :: map() | nil
  @type result :: {:error, String.t()} | {:ok, map()}

  @doc """
  Searches regional data based on a series of code structures.

  Returns `{:ok, data}` if the data is found; otherwise, returns `{:error, "Data not found"}`.
  """
  @spec search_code(data(), atom()) :: result()
  def search_code(nil, _), do: {:error, "Data not found"}
  def search_code(data, type), do: {:ok, extract_data(data, type)}

  defp extract_data(data, type) do
    case type do
      :province -> Map.take(data, ["code", "name"])
      :city -> Map.take(data, ["code", "type", "name"])
      :district -> Map.take(data, ["code", "type", "name"])
      :subdistrict -> Map.take(data, ["code", "type", "name"])
    end
  end
end
