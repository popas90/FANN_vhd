library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;

package PkgConfiguration is
  constant RAM_AddrWidth : integer := 2;
  constant RAM_DataWidth : integer := 4;
  type RAM_t is array (2 ** RAM_AddrWidth - 1 downto 0) of std_logic_vector(RAM_DataWidth - 1 downto 0);

  constant NoOfNeurons : natural := 10;

  constant DataWidth : natural := 16;

  type NoOfInputs_t is array (NoOfNeurons - 1 downto 0) of natural;
  constant NoOfInputs : NoOfInputs_t := (2, 3, 5, 8, 10, 6, 7, 2, 9, 8);

  constant ValidStages : natural := 5;

--constant BRAM_ProcElem1 : RAM_t := ("0000", "0000", "0000", "0000");


end package PkgConfiguration;

package body PkgConfiguration is
end package body PkgConfiguration;
