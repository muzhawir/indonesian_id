defmodule Nip.Pns do
  @moduledoc """
  Functions for working with NIP PNS (Nomor Induk Pegawai Negeri Sipil)

  NIP PNS consists of 18 digits that divided into 4 parts:
  - `8` digits for birth date (`YYYYMMDD`)
  - `6` digits for TMT (Tanggal Mulai Tugas) (`YYYYMM`)
  - `1` digit for sex code (`1` for male and `2` for female)
  - `3` digits for serial number (`001-999`)
  """

  import Nip.Utils

  defstruct [:nip, :birth_date, :tmt_date, :sex, :serial_number]

  @doc """
  Parse NIP PNS into a struct.

  This function returns `{:ok, %Nip.Pns{}}` if the NIP is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Pns.parse("200012312024121001")
      {:ok,
      %Nip.Pns{
        nip: "200012312024121001",
        birth_date: ~D[2000-12-31],
        tmt_date: ~D[2024-12-01],
        sex: "M",
        serial_number: "001"
      }}

  """
  @spec parse(String.t()) :: {:ok, struct()} | {:error, String.t()}
  def parse(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, birth_date} <- get_birth_date(nip),
         {:ok, tmt_date} <- get_tmt(nip),
         {:ok, sex_code} <- get_sex_code(nip),
         {:ok, serial_number} <- get_serial_number(nip) do
      {:ok,
       %Nip.Pns{
         nip: nip,
         birth_date: birth_date,
         tmt_date: tmt_date,
         sex: sex_code,
         serial_number: serial_number
       }}
    end
  end

  @spec get_tmt(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  defp get_tmt(nip) when is_binary(nip) do
    tmt_date_from_nip = String.slice(nip, 8..13)
    year = String.slice(tmt_date_from_nip, 0..3)
    month = String.slice(tmt_date_from_nip, 4..5)
    parses_date = Date.from_iso8601("#{year}-#{month}-01")

    case parses_date do
      {:ok, date} -> {:ok, date}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Validate NIP format.

  This function returns `{:ok, nip}` if the NIP is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Pns.validate_format("200012312024121001")
      {:ok, "200012312024121001"}

  """
  @spec validate_format(String.t()) :: {:ok | :error, String.t()}
  def validate_format(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, _} <- get_birth_date(nip),
         {:ok, _} <- get_tmt(nip),
         {:ok, _} <- get_sex_code(nip),
         {:ok, _} <- get_serial_number(nip) do
      {:ok, nip}
    end
  end
end
