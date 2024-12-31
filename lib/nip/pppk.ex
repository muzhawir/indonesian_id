defmodule Nip.Pppk do
  @moduledoc """
  Functions for working with NIP PPPK (Pegawai Pemerintah dengan Perjanjian Kerja)

  NIP PNS consists of 18 digits that divided into 4 parts:
  - `8` digits for birth date (`YYYYMMDD`)
  - `4` digits for TMT (Tanggal Mulai Tugas) (`YYYY`)
  - `1` digit that indicates the code for PPPK (`2`)
  - `1` digit for frequency (`1-9`)
  - `1` digit for sex code (`1` for male and `2` for female)
  - `3` digits for serial number (`001-999`)
  """

  import Nip.Utils

  defstruct [:nip, :birth_date, :tmt_date, :frequency, :sex, :serial_number]

  @doc """
  Parse NIP PPPK into a struct.

  This function returns `{:ok, %Nip.Pppk{}}` if the NIP is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Pppk.parse("200012312024211001")
      {:ok,
      %Nip.Pppk{
        nip: "200012312024211001",
        birth_date: ~D[2000-12-31],
        tmt_date: ~D[2024-01-01],
        frequency: 1,
        sex: "M",
        serial_number: "001"
      }}

  """
  @spec parse(String.t()) :: {:ok, struct()} | {:error, String.t()}
  def parse(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, birth_date} <- get_birth_date(nip),
         {:ok, tmt_date} <- get_tmt(nip),
         {:ok, _} <- validate_pppk_code(nip),
         {:ok, frequency} <- get_frequency(nip),
         {:ok, sex_code} <- get_sex_code(nip),
         {:ok, serial_number} <- get_serial_number(nip) do
      {:ok,
       %Nip.Pppk{
         nip: nip,
         birth_date: birth_date,
         tmt_date: tmt_date,
         frequency: frequency,
         sex: sex_code,
         serial_number: serial_number
       }}
    end
  end

  @spec get_tmt(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  defp get_tmt(nip) when is_binary(nip) do
    year = nip |> String.slice(8..11) |> String.slice(0..3)
    parses_date = Date.from_iso8601("#{year}-01-01")

    case parses_date do
      {:ok, date} -> {:ok, date}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_pppk_code(String.t()) :: {:ok | :error, String.t()}
  defp validate_pppk_code(nip) when is_binary(nip) do
    if String.slice(nip, 12..12) === "2", do: {:ok, "Valid"}, else: {:error, "Invalid PPPK code"}
  end

  @spec get_frequency(String.t()) :: {:ok, non_neg_integer()} | {:error, String.t()}
  defp get_frequency(nip) when is_binary(nip) do
    frequency = nip |> String.at(13) |> String.to_integer()
    if frequency in 1..9, do: {:ok, frequency}, else: {:error, "frequency out of range"}
  end

  @doc """
  Validate NIP format.

  This function returns `{:ok, nip}` if the NIP is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Pppk.validate_format("200012312024211001")
      {:ok, "200012312024211001"}

  """
  @spec validate_format(String.t()) :: {:ok | :error, String.t()}
  def validate_format(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, _} <- get_birth_date(nip),
         {:ok, _} <- get_tmt(nip),
         {:ok, _} <- validate_pppk_code(nip),
         {:ok, _} <- get_frequency(nip),
         {:ok, _} <- get_sex_code(nip),
         {:ok, _} <- get_serial_number(nip) do
      {:ok, nip}
    end
  end
end
