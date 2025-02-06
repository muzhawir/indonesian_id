defmodule BankTest do
  use ExUnit.Case, async: true

  doctest Bank

  describe "parse/1" do
    test "parse valid bank code" do
      bank =
        {:ok,
         %Bank{
           code: "134",
           name: "Bank Sulteng",
           category: "BPD",
           call_center: "14069",
           url: "https://banksulteng.co.id"
         }}

      Bank.parse("134") === bank
    end

    test "parse invalid bank code" do
      Bank.parse("999") === {:error, "Invalid bank code"}
    end
  end
end
