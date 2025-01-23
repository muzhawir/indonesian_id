defmodule Nip.Pppk do
  @moduledoc """
  Functions for working with NIP PPPK (Pegawai Pemerintah dengan Perjanjian Kerja)

  NIP PPPK consists of 18 digits divided into 6 parts:
  - `8` digits for birth date (`YYYYMMDD`)
  - `4` digits for TMT (Tanggal Mulai Tugas) (`YYYY`)
  - `1` digit that indicates the code for PPPK (`2`)
  - `1` digit for frequency (`1-9`)
  - `1` digit for sex code (`1` for male and `2` for female)
  - `3` digits for serial number (`001-999`)
  """

  import Nip.Utils

  @type nip_result() :: {:ok, t()} | {:error, String.t()}
  @type t() :: %__MODULE__{
          nip: String.t(),
          birth_date: Date.t(),
          tmt_date: Date.t(),
          frequency: integer(),
          sex: String.t(),
          serial_number: String.t()
        }
  @type validated_nip_result() :: {:ok, String.t()} | {:error, String.t()}
  @typep tmt_result() :: {:ok, Date.t()} | {:error, atom()}
  @typep validate_pppk_code_result() :: {:ok, String.t()} | {:error, String.t()}
  @typep frequency_result() :: {:ok, non_neg_integer()} | {:error, String.t()}

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
  @spec parse(String.t()) :: nip_result()
  def parse(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, birth_date} <- birth_date(nip),
         {:ok, tmt_date} <- tmt(nip),
         {:ok, _} <- validate_pppk_code(nip),
         {:ok, frequency} <- frequency(nip),
         {:ok, sex_code} <- sex_code(nip),
         {:ok, serial_number} <- serial_number(nip) do
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

  @spec tmt(String.t()) :: tmt_result()
  defp tmt(nip) when is_binary(nip) do
    year = nip |> String.slice(8..11) |> String.slice(0..3)

    Date.from_iso8601("#{year}-01-01")
  end

  @spec validate_pppk_code(String.t()) :: validate_pppk_code_result()
  defp validate_pppk_code(nip) when is_binary(nip) do
    if String.slice(nip, 12..12) === "2", do: {:ok, "Valid"}, else: {:error, "Invalid PPPK code"}
  end

  @spec frequency(String.t()) :: frequency_result()
  defp frequency(nip) when is_binary(nip) do
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
  @spec validate_format(String.t()) :: validated_nip_result()
  def validate_format(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, _} <- birth_date(nip),
         {:ok, _} <- tmt(nip),
         {:ok, _} <- validate_pppk_code(nip),
         {:ok, _} <- frequency(nip),
         {:ok, _} <- sex_code(nip),
         {:ok, _} <- serial_number(nip) do
      {:ok, nip}
    end
  end
end
