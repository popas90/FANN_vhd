library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkgconfiguration.all;
use work.pkgcomponents.all;

entity Core is
  port(

    -- Global clock signal
    Clk     : in  std_logic;

    -- Global sync reset signal
    Rst     : in  std_logic;

    -- Input data port
    DataIn  : in  std_logic_vector(DataWidth_c - 1 downto 0);

    -- Input identifier port
    IdentIn : in  std_logic_vector(IdentWidth_c - 1 downto 0);

    -- Output data port
    DataOut : out std_logic_vector(DataWidth_c - 1 downto 0)
  );
end entity Core;

architecture RTL of Core is

  -- the DataReg is the data source for the D port
  signal DataReg    : std_logic_vector(DataWidth_c - 1 downto 0) := (others => '0');
  signal DataRegIn  : std_logic_vector(DataWidth_c - 1 downto 0);
  signal DataRegEn  : boolean;
  signal DataRegSel : std_logic;

  -- the BramAddrReg is used for computing the read addresses for the BRAMs
  signal MemBaseReg    : std_logic_vector(WeightsMemoryAddrWidth_c - 1 downto 0) := (others => '0');
  signal MemBaseRegIn  : std_logic_vector(WeightsMemoryAddrWidth_c - 1 downto 0);
  signal MemBaseRegEn  : boolean;
  signal MemBaseRegSel : std_logic;

  -- actual read address ports for BRAM1 (coeffs) and BRAM2 (weights)
  signal CoeffsMemRdAddr : std_logic_vector(CoeffsMemoryAddrWidth_c - 1 downto 0);
  signal WeightsMemRdAddr : std_logic_vector(WeightsMemoryAddrWidth_c - 1 downto 0);

  -- selector for BRAM1 read address:
  --      - "00" - a
  --      - "01" - f(a)
  --      - "10" - f'(a)
  --      - "11" - 1/2*f"(a)
  signal CoeffsMemAddrSel : std_logic_vector(CoeffsMemorySelWidth_c - 1 downto 0);

  -- selector for BRAM2 read address:
  -- signal WeightsMemRdAddrSel : std_logic_vector(1 downto 0);

  -- the output register from the DSP
  signal DspOutReg : std_logic_vector(47 downto 0);
  
  -- enable signals for the BRAM cores
  signal CoeffsMemEn : boolean;
  signal WeightsMemEn : boolean;

  -- output busses from memories
  signal CoeffsMemDataOut : std_logic_vector(DataWidth_c - 1 downto 0);

begin
  DataRegIn    <= DataIn when DataRegSel = '0' else DspOutReg(DataWidth_c - 1 downto 0);
  MemBaseRegIn <= ((others => '0') & IdentIn) when MemBaseRegSel = '0' else ((others => '0') & DspOutReg(WeightsMemoryAddrWidth_c - CoeffsMemorySelWidth_c - 1 downto 0));

  DataRegister : process(Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
        DataReg <= (others => '0');
      elsif DataRegEn then
        DataReg <= DataRegIn;
      end if;
    end if;
  end process;

  MemoryBaseRegister : process(Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
        MemBaseReg <= (others => '0');
      elsif MemBaseRegEn then
        MemBaseReg <= MemBaseRegIn;
      end if;
    end if;
  end process;

  -- CoeffsMemory - interleaved a, f(a),f'(a) and 1/2*f"(a)
  -- configured as a read-only memory, single-port

  CoeffsMemRdAddr <= MemBaseReg & CoeffsMemAddrSel;
  
  CoefficientsMemory: component BRAM_DualPort_Init
    generic map(BlockRamInitFile_g => "dummy.txt")
    port map(Clk      => Clk,
             En       => CoeffsMemEn,
             WrEnA    => false,
             AddrA    => unsigned(CoeffsMemRdAddr),
             AddrB    => (others => '0'),
             DataInA  => (others => '0'),
             DataOutA => CoeffsMemDataOut,
             DataOutB => open);

  -- WeightsMemory - interleaved weights from different neurons
  -- the number of weights depends on the number of inputs
  -- the bias address for each neuron is set as constant
  -- and is considered the last weight
 
  WeightsMemRdAddr <= MemBaseReg; -- & Bram2RdAddrSel;

end architecture RTL;
