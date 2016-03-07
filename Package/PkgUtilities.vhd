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
  constant RamInit_AddrWidth_c : integer := 9;
  constant RamInit_DataWidth_c : integer := 16;
  -- this is equivalent to the one-line declaration of RamInit_t, but it avoids a GHDL warning
  type Mem_t is array (integer range <>) of bit_vector(RamInit_DataWidth_c - 1 downto 0);
  subtype RamInit_t is Mem_t(0 to (2 ** RamInit_AddrWidth_c - 1));
  --type RamInit_t is array ((2 ** RamInit_AddrWidth_c) - 1 downto 0) of bit_vector(RamInit_DataWidth_c - 1 downto 0);

  -- reads FILE and returns BRAM contents
  impure function BlockRamInit_f(FileName : in string) return RamInit_t;

  -- conversion functions
  function to_boolean(input : std_logic) return boolean;
  function to_stdLogic(input : boolean) return std_logic;

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

  function to_boolean(input : std_logic) return boolean is
  begin
    if input = '1' then
      return true;
    end if;
    return false;
  end function;

  function to_stdLogic(input : boolean) return std_logic is
  begin
    if input then
      return '1';
    end if;
    return '0';
  end function;

end package body PkgUtilities;
