defmodule Regional.Data do
  @moduledoc false

  @doc """
  Retrieves the regional JSON data.

  Returns the decoded JSON data if successful, otherwise raises an error.
  """
  @spec get_regional_data!() :: map() | no_return()
  def get_regional_data!, do: get_data_file_path() |> File.read!() |> JSON.decode!()

  # The path to the minifed JSON file is `priv/nik/minified_regional_data.json`.
  # The path to the original JSON file is `priv/nik/regional_data.json`.
  defp get_data_file_path do
    Path.join([File.cwd!(), "priv", "nik", "minified_regional_data.json"])
  end
end
