defmodule Nip.Utils do
  @moduledoc false

  @doc """
  Validate NIP length, must be 18 characters.

  ## Examples

      iex> Nip.Utils.validate_length("196711101992031001")
      {:ok, "196711101992031001"}

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

  ## Examples

      iex> Nip.Utils.get_birth_date("196711101992031001")
      {:ok, ~D[1967-11-10]}

  """
  @spec get_birth_date(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def get_birth_date(nip) when is_binary(nip) do
    birth_date_from_nip = String.slice(nip, 0..7)

    year = String.slice(birth_date_from_nip, 0..3)

    month = String.slice(birth_date_from_nip, 4..5)

    day = String.slice(birth_date_from_nip, 6..7)

    date = Date.from_iso8601("#{year}-#{month}-#{day}")

    case date do
      {:ok, value} -> {:ok, value}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Get sex code from NIP.

  ## Examples

      iex> Nip.Utils.get_sex_code("196711101992031001")
      {:ok, "M"}

  """
  @spec get_sex_code(String.t()) :: {:ok | :error, String.t()}
  def get_sex_code(nip) when is_binary(nip) do
    sex_from_nip = String.slice(nip, 14..14)

    cond do
      sex_from_nip == "1" -> {:ok, "M"}
      sex_from_nip == "2" -> {:ok, "F"}
      true -> {:error, "Invalid sex code"}
    end
  end

  @doc """
  Get serial number from NIP.

  ## Examples

      iex> Nip.Utils.get_serial_number("196711101992031001")
      {:ok, "001"}

  """
  @spec get_serial_number(String.t()) :: {:ok | :error, String.t()}
  def(get_serial_number(nip) when is_binary(nip)) do
    serial_number_from_nip = String.slice(nip, 15..18)

    if String.to_integer(serial_number_from_nip) in 1..999 do
      {:ok, serial_number_from_nip}
    else
      {:error, "Serial number out of range"}
    end
  end
end
