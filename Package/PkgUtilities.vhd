library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

package PkgUtilities is

  -- operations defined for a PE Core
  type CoreOperation_t is (NoOperation, ForwardPass, BackwardPass);

  -- 8-bit natural type
  subtype ShortNatural_t is integer range 0 to 255;

  -- array of booleans
  type BooleanArray_t is array (natural range <>) of boolean;

  -- block memory type
  constant RamInit_AddrWidth_c : natural := 9;
  constant RamInit_DataWidth_c : natural := 16;
  type RamInit_t is array (2 ** RamInit_AddrWidth_c - 1 downto 0) of bit_vector(RamInit_DataWidth_c - 1 downto 0);

  -- reads FILE and returns BRAM contents
  impure function BlockRamInit_f(FileName : in string) return RamInit_t;

end package PkgUtilities;

package body PkgUtilities is
  impure function BlockRamInit_f(FileName : in string) return RamInit_t is
    FILE RamFile : text is in FileName;
    variable LineName : line;
    variable RamName  : RamInit_t;
  begin
    for i in RamInit_t'range loop
      readline(RamFile, LineName);
      read(LineName, RamName(i));
    end loop;
    return RamName;
  end function;

end package body PkgUtilities;
