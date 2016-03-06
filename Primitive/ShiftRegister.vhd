library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftRegister is
  generic (
    Length_g : natural := 16);
  port (
    Clk      : in  std_logic;
    Data_in  : in  std_logic;
    Data_out : out std_logic);
end entity ShiftRegister;

architecture rtl of ShiftRegister is
  signal DataReg : std_logic_vector(Length_g - 1 downto 0) := (others => '0');
begin
  Shift: process (Clk)
  begin
    if rising_edge(Clk) then
      DataReg <= DataReg(Length_g - 2 downto 0) & Data_in;
    end if;
  end process Shift;

  Data_out <= DataReg(Length_g);

end architecture rtl;
