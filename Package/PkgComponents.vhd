library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;

package PkgComponents is

  component BRAM_DualPort_Init is
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
  end component BRAM_DualPort_Init;

  component ShiftRegister is
    generic (
      Length_g : natural := 16);
    port (
      Clk      : in  std_logic;
      Data_in  : in  std_logic;
      Data_out : out std_logic);
  end component ShiftRegister;

  component ShiftRegisterBool is
    generic (
      Length_g : natural := 16);
    port (
      Clk      : in  std_logic;
      Data_in  : in  boolean;
      Data_out : out boolean);
  end component ShiftRegisterBool;

  component SyncResetCtrl is
    port (
      Clk     : in  std_logic;
      SyncRst : out boolean);
  end component SyncResetCtrl;

  component LinearController is
    generic (
      NoOfInputs_g : ShortNatural_t := 8;
      PipelineDly_g : ShortNatural_t := 4);
    port (
      Clk : in  std_logic;
      SyncRst : in  boolean;
      InputValid_in : in  boolean;
      OutputValid_out : out boolean);
  end component;

end package PkgComponents;
