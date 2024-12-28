defmodule Nip.Pns do
  @moduledoc """
  Functions for working with NIP PNS (Nomor Induk Pegawai Negeri Sipil)
  """

  import Nip.Utils

  defstruct [:nip, :birth_date, :tmt_date, :sex, :serial_number]

  @doc """
  Parse NIP PNS into a struct.

  ## Examples

      iex> Nip.Pns.parse("196711101992031001")
      {:ok,
      %Nip.Pns{
        nip: "196711101992031001",
        birth_date: "1967-11-10",
        tmt_date: "1992-03-01",
        sex: "M",
        serial_number: "001"
      }}

  """
  @spec parse(String.t()) :: {:ok, struct()} | {:error, String.t()}
  def parse(nip) when is_binary(nip) do
    with {:ok, _} <- validate_nip_length(nip),
         {:ok, birth_date} <- get_birth_date(nip),
         {:ok, tmt_date} <- get_tmt(nip),
         {:ok, sex_code} <- get_sex_code(nip),
         {:ok, serial_number} <- get_serial_number(nip) do
      parsed_value = %Nip.Pns{
        nip: nip,
        birth_date: Date.to_string(birth_date),
        tmt_date: Date.to_string(tmt_date),
        sex: sex_code,
        serial_number: serial_number
      }

      {:ok, parsed_value}
    end
  end

  @doc """
  Get TMT (Tanggal Mulai Tugas) from NIP.

  ## Exammples

      iex> Nip.Pns.get_tmt("196711101992031001")
      {:ok, ~D[1992-03-01]}

  """
  @spec get_tmt(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def get_tmt(nip) when is_binary(nip) do
    tmt_date_from_nip = String.slice(nip, 8..13)

    year = String.slice(tmt_date_from_nip, 0..3)

    month = String.slice(tmt_date_from_nip, 4..5)

    date = Date.from_iso8601("#{year}-#{month}-01")

    case date do
      {:ok, _} -> date
      {:error, :invalid_format} -> {:error, "Invalid TMT date format, must be YYYYMM"}
      {:error, :invalid_date} -> {:error, "Invalid TMT date, must be valid date format"}
    end
  end
end
