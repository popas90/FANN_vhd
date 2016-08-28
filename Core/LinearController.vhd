library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;
use work.PkgComponents.all;
use work.PkgUtilities.all;

entity LinearController is
  generic (
    NoOfInputs_g  : ShortNatural_t := 8;
    PipelineDly_g : ShortNatural_t := 4);
  port (
    Clk : in  std_logic;
    SyncRst : in  boolean;
    InputValid_in : in  boolean;
    OutputValid_out : out boolean);
end entity;

architecture rtl of LinearController is
  signal InputCnt : ShortNatural_t := 0;
  signal ShiftRegOut, ShiftRegOutDly : boolean := false;
  signal OutputValid : boolean;
begin

  UpdateCount: process(Clk)
  begin
    if rising_edge(Clk) then
      if (SyncRst or OutputValid) then
        InputCnt <= NoOfInputs_g;
      elsif ShiftRegOut then
        InputCnt <= InputCnt - 1;
      end if;
    end if;
  end process;

  EnableShiftReg: ShiftRegisterBool
    generic map (
      Length_g => PipelineDly_g)
    port map (
      Clk      => Clk,
      Data_in  => InputValid_in,
      Data_out => ShiftRegOut);

  DelayShiftRegOut: process(Clk)
  begin
    if rising_edge(Clk) then
      if SyncRst then
        ShiftRegOutDly <= false;
      else
        ShiftRegOutDly <= ShiftRegOut;
      end if;
    end if;
  end process;

OutputValid <= ShiftRegOutDly and (InputCnt = 0);
OutputValid_out <= OutputValid;
end architecture rtl;
