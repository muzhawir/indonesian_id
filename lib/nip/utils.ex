defmodule Nip.Utils do
  @moduledoc false

  @doc """
  Validate NIP length, must be 18 characters.

  This function returns `{:ok, nip}` if the length is valid, otherwise `{:error, "Invalid length"}`.

  ## Examples

      iex> Nip.Utils.validate_length("200012312024121001")
      {:ok, "200012312024121001"}

  """
  @spec validate_length(String.t()) :: {:ok | :error, String.t()}
  def validate_length(nip) when is_binary(nip) do
    if String.length(nip) === 18 do
      {:ok, nip}
    else
      {:error, "Invalid length"}
    end
  end

  @doc """
  Get birth date from NIP.

  This function returns `{:ok, date}` with date sigil at the second element if the date is valid,
  otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Utils.get_birth_date("200012312024121001")
      {:ok, ~D[2000-12-31]}

  """
  @spec get_birth_date(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def get_birth_date(nip) when is_binary(nip) do
    extracted_date = String.slice(nip, 0..7)
    year = String.slice(extracted_date, 0..3)
    month = String.slice(extracted_date, 4..5)
    day = String.slice(extracted_date, 6..7)
    birth_date = Date.from_iso8601("#{year}-#{month}-#{day}")

    case birth_date do
      {:ok, value} -> {:ok, value}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Get sex code from NIP.

  This function returns:
  - `{:ok, "M"}` if the code is 1 that indicates Male.
  - `{:ok, "F"}` if the code is 2 that indicates Female.
  - `{:error, "Invalid sex number code"}` if code is invalid.

  ## Examples

      iex> Nip.Utils.get_sex_code("200012312024121001")
      {:ok, "M"}

  """
  @spec get_sex_code(String.t()) :: {:ok | :error, String.t()}
  def get_sex_code(nip) when is_binary(nip) do
    sex_number_code = String.slice(nip, 14..14)

    cond do
      sex_number_code == "1" -> {:ok, "M"}
      sex_number_code == "2" -> {:ok, "F"}
      true -> {:error, "Invalid sex number code"}
    end
  end

  @doc """
  Get serial number from NIP.

  This function returns `{:ok, serial_number}` if the serial number in range 1-999,
  otherwise `{:error, "Serial number out of range"}`.

  ## Examples

      iex> Nip.Utils.get_serial_number("200012312024121001")
      {:ok, "001"}

  """
  @spec get_serial_number(String.t()) :: {:ok | :error, String.t()}
  def(get_serial_number(nip) when is_binary(nip)) do
    extracted_serial_number = String.slice(nip, 15..18)

    if String.to_integer(extracted_serial_number) in 1..999 do
      {:ok, extracted_serial_number}
    else
      {:error, "Serial number out of range"}
    end
  end
end
