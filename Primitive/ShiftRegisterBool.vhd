library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftRegisterBool is
  generic (
    Length_g : natural := 16);
  port (
    Clk      : in  std_logic;
    Data_in  : in  boolean;
    Data_out : out boolean);
end entity ShiftRegisterBool;

architecture rtl of ShiftRegisterBool is
  signal DataReg : BooleanArray_t(Length_g - 1 downto 0) := (others => false);
begin
  Shift: process (Clk)
  begin
    if rising_edge(Clk) then
      DataReg <= DataReg(Length_g - 2 downto 0) & Data_in;
    end if;
  end process Shift;

  Data_out <= DataReg(Length_g);

end architecture rtl;
