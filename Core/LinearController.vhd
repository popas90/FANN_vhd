library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;
use work.PkgComponents.all;
use work.PkgUtilities.all;

entity LinearController is
  generic (
    NoOfInputs_g : ShortNatural_t := 4);
  port (
    Clk : in  std_logic;
    SyncRst : in  boolean;
    InputValid_in : in  boolean;
    OutputValid_out : out boolean);
end entity;

architecture rtl of LinearController is
  signal InputCnt : ShortNatural_t := 0;
  signal ShiftRegOut, OutputValidLoc : boolean;
begin

  UpdateCount: process(Clk)
  begin
    if rising_edge(Clk) then
      if (SyncRst or OutputValidLoc) then
        InputCnt <= 0;
      elsif InputValid_in then
        InputCnt <= InputCnt + 1;
      end if;
    end if;
  end process;

  EnableShiftReg: ShiftRegisterBool
    generic map (
      Length_g => 5)
    port map (
      Clk      => Clk,
      Data_in  => InputValid_in,
      Data_out => ShiftRegOut);

OutputValidLoc <= ShiftRegOut and (InputCnt = NoOfInputs_g);
end architecture rtl;
