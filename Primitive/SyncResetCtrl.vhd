library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgUtilities.all;

entity SyncResetCtrl is
  port (
    Clk     : in  std_logic;
    SyncRst : out boolean);
end entity SyncResetCtrl;

architecture rtl of SyncResetCtrl is
  signal Q1, Q2, Q3 : std_logic := '1';
begin

  -- Use a chain of three FFs, all intialized to '1', so the reset starts
  -- as active. The input of the first reset is tied to '0' and will propagate
  -- through the chain, thus giving a synchronous deassertion for the reset.

  FirstFlop : FDRE
   generic map (
      INIT => '1') -- Initial value of register ('0' or '1')
   port map (
      Q  => Q1,     -- Data output
      C  => Clk,    -- Clock input
      CE => '1',    -- Clock enable input
      R  => '0',    -- Synchronous reset input
      D  => '0'     -- Data input
   );

   SecondFlop : FDRE
   generic map (
      INIT => '1') -- Initial value of register ('0' or '1')
   port map (
      Q  => Q2,     -- Data output
      C  => Clk,    -- Clock input
      CE => '1',    -- Clock enable input
      R  => '0',    -- Synchronous reset input
      D  => Q1      -- Data input
   );

   ThirdFlop : FDRE
   generic map (
      INIT => '1') -- Initial value of register ('0' or '1')
   port map (
      Q  => Q3,     -- Data output
      C  => Clk,    -- Clock input
      CE => '1',    -- Clock enable input
      R  => '0',    -- Synchronous reset input
      D  => Q2      -- Data input
   );

   SyncRst <= to_boolean(Q3);

end architecture rtl;
