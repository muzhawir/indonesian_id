defmodule Nip.Pns do
  @moduledoc """
  Functions for working with NIP PNS (Nomor Induk Pegawai Negeri Sipil)
  """

  import Nip.Utils

  defstruct [:nip, :birth_date, :tmt_date, :sex, :serial_number]

  @doc """
  Parse NIP PNS into a struct.

  ## Examples

      iex> Nip.Pns.parse("200012312024121001")
      {:ok,
         %Pns{
           nip: "200012312024121001",
           birth_date: "2000-12-31",
           tmt_date: "2024-12-01",
           sex: "M",
           serial_number: "001"
         }}

  """
  @spec parse(String.t()) :: {:ok, struct()} | {:error, String.t()}
  def parse(nip) when is_binary(nip) do
    case validate_format(nip) do
      {:ok, _} ->
        {_, birth_date} = get_birth_date(nip)

        {_, tmt_date} = get_tmt(nip)

        {_, sex_code} = get_sex_code(nip)

        {_, serial_number} = get_serial_number(nip)

        {:ok,
         %Nip.Pns{
           nip: nip,
           birth_date: Date.to_string(birth_date),
           tmt_date: Date.to_string(tmt_date),
           sex: sex_code,
           serial_number: serial_number
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Get TMT (Tanggal Mulai Tugas) from NIP.

  ## Exammples

      iex> Nip.Pns.get_tmt("200012312024121001")
      {:ok, ~D[2024-12-01]}

  """
  @spec get_tmt(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def get_tmt(nip) when is_binary(nip) do
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
