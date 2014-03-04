library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAM_DualPort is
	generic(
		AddrWidth : integer := 9;
		DataWidth : integer := 16
	);
	port (
		Clk : in std_logic;
		En  : in std_logic;
		WrEnA : in std_logic;
		AddrA : in unsigned(AddrWidth-1 downto 0);
		AddrB : in unsigned(AddrWidth-1 downto 0);
		DataInA : in std_logic_vector(DataWidth-1 downto 0);
		DataOutA : out std_logic_vector(DataWidth-1 downto 0);
		DataOutB : out std_logic_vector(DataWidth-1 downto 0)
	);
end entity BRAM_DualPort;

architecture RTL of BRAM_DualPort is

type BlockRAM_t is array (2**AddrWidth-1 downto 0) of std_logic_vector (DataWidth-1 downto 0);
signal Memory: BlockRAM_t;
	
begin

process (Clk)
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
