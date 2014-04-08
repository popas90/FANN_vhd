library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;

package PkgConfiguration is

  type Dsp48Type_t is (DSP48A1, DSP48E1);
  constant DspConfig_c : Dsp48Type_t := DSP48A1;

  constant NoOfNeurons_c : natural := 10;

  constant DataWidth_c : natural := 16;
  constant IdentWidth_c : natural := 16;
  constant BramAddrWidth_c : natural := 9;

  type NoOfInputs_t is array (NoOfNeurons_c - 1 downto 0) of natural;
  constant NoOfInputs_c : NoOfInputs_t := (2, 3, 5, 8, 10, 6, 7, 2, 9, 8);

  constant Bram1BiasAddr_c : std_logic_vector (BramAddrWidth_c - 1 downto 0) := x"FFFF";
--constant BRAM_ProcElem1 : RAM_t := ("0000", "0000", "0000", "0000");


end package PkgConfiguration;

package body PkgConfiguration is
end package body PkgConfiguration;
