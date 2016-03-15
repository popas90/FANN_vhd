library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;

package PkgConfiguration is

  type Dsp48Type_t is (DspBlock48A1, DspBlock48E1);
  constant DspConfig_c : Dsp48Type_t := DspBlock48A1;

  constant NoOfNeurons_c : natural := 10;

  -- depths for coeffs and weights memories
  -- keep these equal !!!
  -- otherwise, MemBaseReg from Core must also change
  constant CoeffsMemoryAddrWidth_c : natural := RamInit_AddrWidth_c; -- 10 for K7
  constant WeightsMemoryAddrWidth_c : natural := RamInit_AddrWidth_c; -- 10 for K7

  -- selectors for the interleaving mechanism
  -- the coeffs mem interleaves a, f(a), f'(a), 1/2*f"(a)
  constant CoeffsMemorySelWidth_c : natural := 2;
  -- the weights mem interleaves different numbers of inputs
  -- currently, this line is commented out, because i
  -- want basic functionality for one emulated neuron first
  -- constant WeightsMemorySelWidth_c : natural := 1;

  type NoOfInputs_t is array (NoOfNeurons_c - 1 downto 0) of natural;
  constant NoOfInputs_c : NoOfInputs_t := (2, 3, 5, 8, 10, 6, 7, 2, 9, 8);

--constant Bram1BiasAddr_c : std_logic_vector (BramAddrWidth_c - 1 downto 0) := x"FFFF";
--constant BRAM_ProcElem1 : RAM_t := ("0000", "0000", "0000", "0000");

end package PkgConfiguration;
