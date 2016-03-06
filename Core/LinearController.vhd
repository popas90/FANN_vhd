library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;

entity LinearController is
  generic (
    NoOfInputs_g : ShortNatural_t := 4);
  port (
    Clk : in  std_logic;
    AsyncRst : in  std_logic;

    InputValid_in : in  boolean;
    OutputValid_out : out boolean);
end entity;

architecture rtl of LinearController is
  constant InputCnt : ShortNatural_t := 0;
begin

  UpdateCount: process(AsyncRst, Clk)
  begin
    if AsyncRst then
      InputCnt <= 0;
    elsif rising_edge(Clk) then
      if InputValid_in then
        InputCnt <= InputCnt + 1;
      end if;
    end if;
  end process;

end architecture rtl;
