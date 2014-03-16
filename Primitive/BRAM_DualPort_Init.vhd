library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;

entity BRAM_DualPort_Init is
  generic(
    InitMem : RAM_t := (others => (others => '0'))
  );
  port(
    Clk      : in  std_logic;
    En       : in  std_logic;
    WrEnA    : in  std_logic;
    AddrA    : in  unsigned(RAM_AddrWidth - 1 downto 0);
    AddrB    : in  unsigned(RAM_AddrWidth - 1 downto 0);
    DataInA  : in  std_logic_vector(RAM_DataWidth - 1 downto 0);
    DataOutA : out std_logic_vector(RAM_DataWidth - 1 downto 0);
    DataOutB : out std_logic_vector(RAM_DataWidth - 1 downto 0)
  );
end entity BRAM_DualPort_Init;

architecture RTL of BRAM_DualPort_Init is

  signal Memory : RAM_t := InitMem;

begin
  process(Clk)
  begin
    if rising_edge(Clk) then
      if (En = '1') then
        if (WrEnA = '1') then
          Memory(to_integer(AddrA)) <= DataInA;
        end if;
        DataOutA <= Memory(to_integer(AddrA));
        DataOutB <= Memory(to_integer(AddrB));
      end if;
    end if;
  end process;
end architecture RTL;
