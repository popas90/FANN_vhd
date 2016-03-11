library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgUtilities.all;
use work.PkgComponents.all;

entity tb_LinearController is
end entity tb_LinearController;

architecture test of tb_LinearController is
  constant ClkHalfPeriod_c : time := 10 ns;
  signal Clk : std_logic := '0';
  signal SyncRst, InputValid, OutputValid : boolean := true;
  signal StopSim : boolean := false;
begin

  Clk <= not Clk after ClkHalfPeriod_c when not StopSim else '0';

  DUT: LinearController
    generic map (
      NoOfInputs_g => 5)
    port map (
      Clk => Clk,
      SyncRst => SyncRst,
      InputValid_in => InputValid,
      OutputValid_out => OutputValid);

  MainProc: process
  begin
    SyncRst <= true;
    wait for ClkHalfPeriod_c * 2;
    SyncRst <= false;

    -- TODO

    report "TEST PASSED";
    StopSim <= true;
    wait;

  end process;
end architecture test;
