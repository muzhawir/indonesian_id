defmodule Nip.Pppk do
  @moduledoc """
  Functions for working with NIP PPPK (Pegawai Pemerintah dengan Perjanjian Kerja)
  """

  import Nip.Utils

  defstruct [:nip, :birth_date, :tmt_date, :frequency, :sex, :serial_number]

  @doc """
  Parse NIP PPPK into a struct.

  ## Examples

      iex> Nip.Pppk.parse("200012312024211001")
      {:ok,
      %Nip.Pppk{
        nip: "200012312024211001",
        birth_date: "2000-12-31",
        tmt_date: "2024-01-01",
        frequency: "1",
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

        {_, frequency} = get_frequency(nip)

        {_, sex_code} = get_sex_code(nip)

        {_, serial_number} = get_serial_number(nip)

        {:ok,
         %Nip.Pppk{
           nip: nip,
           birth_date: Date.to_string(birth_date),
           tmt_date: Date.to_string(tmt_date),
           frequency: frequency,
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

      iex> Nip.Pppk.get_tmt("200012312024211001")
      {:ok, ~D[2024-01-01]}

  """
  @spec get_tmt(String.t()) :: {:ok, Date.t()} | {:error, String.t()}
  def get_tmt(nip) when is_binary(nip) do
    year = nip |> String.slice(8..11) |> String.slice(0..3)

    parses_date = Date.from_iso8601("#{year}-01-01")

    case parses_date do
      {:ok, date} -> {:ok, date}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_pppk_code(String.t()) :: {:ok | :error, boolean()}
  defp validate_pppk_code(nip) when is_binary(nip) do
    if String.slice(nip, 12..12) === "2", do: {:ok, true}, else: {:error, false}
  end

  @doc """
  Get frequency from NIP.

  ## Examples

      iex> Nip.Pppk.get_frequency("200012312024211001")
      {:ok, "1"}

  """
  @spec get_frequency(String.t()) :: {:ok | :error, String.t()}
  def get_frequency(nip) when is_binary(nip) do
    frequency = String.slice(nip, 13..13)

    if String.to_integer(frequency) in 1..9 do
      {:ok, frequency}
    else
      {:error, "frequency out of range"}
    end
  end

  @doc """
  Validate NIP format.

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
         {:ok, _} <- get_sex_code(nip),
         {:ok, _} <- get_serial_number(nip) do
      {:ok, nip}
    end
  end
end
