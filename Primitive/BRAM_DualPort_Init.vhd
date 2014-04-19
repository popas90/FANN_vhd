library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;
use work.PkgUtilities.all;

entity BRAM_DualPort_Init is
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
end entity BRAM_DualPort_Init;

architecture RTL of BRAM_DualPort_Init is

  signal Memory : RamInit_t := BlockRamInit_f(BlockRamInitFile_g);

begin
  process(Clk)
  begin
    if rising_edge(Clk) then
      if En then
        if WrEnA then
          Memory(to_integer(AddrA)) <= to_bitvector(DataInA);
        end if;
        DataOutA <= to_stdlogicvector(Memory(to_integer(AddrA)));
        DataOutB <= to_stdlogicvector(Memory(to_integer(AddrB)));
      end if;
    end if;
  end process;
end architecture RTL;
