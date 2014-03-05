library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PkgConfiguration is

  constant RAM_AddrWidth : integer := 2;
  constant RAM_DataWidth : integer := 4;
  type RAM_t is array (2 ** RAM_AddrWidth - 1 downto 0) of std_logic_vector(RAM_DataWidth - 1 downto 0);
  
  constant BRAM_ProcElem1 : RAM_t := ("0000", "0000", "0000", "0000");
  
  
end package PkgConfiguration;

package body PkgConfiguration is
  
end package body PkgConfiguration;
