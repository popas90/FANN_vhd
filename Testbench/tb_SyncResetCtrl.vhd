library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
--use work.PkgConfiguration.all;
--use work.PkgUtilities.all;
use work.PkgComponents.all;

entity tb_SyncResetCtrl is
end entity tb_SyncResetCtrl;

architecture test of tb_SyncResetCtrl is
  constant ClkHalfPeriod_c : time := 10 ns;
  signal Clk : std_logic := '0';
  signal SyncRst : boolean := true;
  signal StopSim : boolean := false;
begin

  Clk <= not Clk after ClkHalfPeriod_c when not StopSim else '0';

  DUT: SyncResetCtrl
    port map (
      Clk     => Clk,
      SyncRst => SyncRst);

  MainProc: process
  begin
    wait for ClkHalfPeriod_c * 20;
  end process;
end architecture test;
