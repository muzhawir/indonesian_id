defmodule Regional.Data do
  @moduledoc false

  @type posix_error :: :file.posix()

  @doc """
  Retrieves regional JSON data.

  Returns the decoded JSON data if successful, otherwise raises an error.

  The path to the minifed JSON file is `priv/nik/minified_regional_data.json`.
  The path to the original JSON file is `priv/nik/regional_data.json`.
  """
  @spec regional_data!() :: term()
  def regional_data! do
    json_file_path = Path.join([File.cwd!(), "priv", "nik", "minified_regional_data.json"])
    json_file_path |> File.read!() |> JSON.decode!()
  end
end
