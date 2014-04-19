library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;
use work.PkgUtilities.all;

package PkgComponents is

  component BRAM_DualPort_Init is
  generic(
    BlockRamInitFile_g : string := "bram_init.txt"
  );
  port(
    Clk      : in  std_logic;
    En       : in  boolean;
    WrEnA    : in  boolean;
    AddrA    : in  unsigned(RamInit_AddrWidth_c - 1 downto 0);
    AddrB    : in  unsigned(RamInit_AddrWidth_c - 1 downto 0);
    DataInA  : in  std_logic_vector(RamInit_DataWidth_c - 1 downto 0);
    DataOutA : out std_logic_vector(RamInit_DataWidth_c - 1 downto 0);
    DataOutB : out std_logic_vector(RamInit_DataWidth_c - 1 downto 0)
  );
  end component BRAM_DualPort_Init;
  
end package PkgComponents;

package body PkgComponents is
  
end package body PkgComponents;
