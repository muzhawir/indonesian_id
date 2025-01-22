defmodule Nip.Pns do
  @moduledoc """
  Functions for working with NIP PNS (Nomor Induk Pegawai Negeri Sipil)

  NIP PNS consists of 18 digits divided into 4 parts:
  NIP PNS consists of 18 digits that divided into 4 parts:
  - `8` digits for birth date (`YYYYMMDD`)
  - `6` digits for TMT (Tanggal Mulai Tugas) (`YYYYMM`)
  - `1` digit for sex code (`1` for male and `2` for female)
  - `3` digits for serial number (`001-999`)
  """

  import Nip.Utils

  @type nip_result() :: {:ok, t()} | {:error, String.t()}
  @type t :: %__MODULE__{
          nip: String.t(),
          birth_date: Date.t(),
          tmt_date: Date.t(),
          sex: String.t(),
          serial_number: String.t()
        }
  @type date_result() :: {:ok, Date.t()} | {:error, String.t()}

  defstruct [:nip, :birth_date, :tmt_date, :sex, :serial_number]

  @doc """
  Parse NIP PNS into a struct.

  Returns `{:ok, %Nip.Pns{}}` if the NIP is valid, otherwise `{:error, reason}`.

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
  @spec parse(String.t()) :: nip_result()
  def parse(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, birth_date} <- birth_date(nip),
         {:ok, tmt_date} <- tmt_date(nip),
         {:ok, sex} <- sex_code(nip),
         {:ok, serial_number} <- serial_number(nip) do
      {:ok,
       %Nip.Pns{
         nip: nip,
         birth_date: birth_date,
         tmt_date: tmt_date,
         sex: sex,
         serial_number: serial_number
       }}
    end
  end

  @spec tmt_date(String.t()) :: date_result()
  defp tmt_date(nip) when is_binary(nip) do
    year = String.slice(nip, 8..11)
    month = String.slice(nip, 12..13)

    Date.from_iso8601("#{year}-#{month}-01")
  end

  @doc """
  Validate NIP format.

  Returns `{:ok, nip}` if the NIP is valid, otherwise `{:error, reason}`.

  ## Examples

      iex> Nip.Pns.validate_format("200012312024121001")
      {:ok, "200012312024121001"}

  """
  @spec validate_format(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_format(nip) when is_binary(nip) do
    with {:ok, _} <- validate_length(nip),
         {:ok, _} <- birth_date(nip),
         {:ok, _} <- tmt_date(nip),
         {:ok, _} <- sex_code(nip),
         {:ok, _} <- serial_number(nip) do
      {:ok, nip}
    end
  end
end
