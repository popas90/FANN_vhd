library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgConfiguration.all;
use work.PkgComponents.all;
use work.PkgUtilities.all;

entity Neuron is
  generic (
    -- How many inputs does the neuron have. Used to reset the counter inside
    -- the LinearController
    NoOfInputs_g : ShortNatural_t := 4;
    -- Path to initialization file for weights memory
    WeightsMemInitFile_g : string);
  port (
    -- Global clock signal
    Clk               : in  std_logic;
    -- Global synchronous reset
    SyncRst           : in  boolean;
    -- Data ports
    Data_in           : in  NeuronData_t;
    Data_out          : out NeuronData_t;
    -- Control signals
    InputValid_in     : in  boolean;
    ReadyForInput_out : out boolean;
    ReadyForOutput_in : in  boolean;
    OutputValid_out   : out boolean);
end entity Neuron;

architecture rtl of Neuron is
  signal WeightsMemDataOut : std_logic_vector(RamInit_DataWidth_c - 1 downto 0);
begin

  WeightsMemory: BRAM_DualPort_Init
    generic map (
      BlockRamInitFile_g => WeightsMemInitFile_g)
    port map (
      Clk                => Clk,
      En                 => true,   -- always reading
      WrEnA              => false,  -- never writing, for now
      AddrA              => resize(Data_in.Identifier, RamInit_AddrWidth_c),
      AddrB              => (others => '0'),
      DataInA            => resize(Data_in.Value, RamInit_DataWidth_c),
      DataOutA           => WeightsMemDataOut,
      DataOutB           => open);

  
end architecture rtl;
