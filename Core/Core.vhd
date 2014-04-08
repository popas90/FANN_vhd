library ieee;
use ieee.std_logic_1164.all;

use work.pkgconfiguration.all;

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
  signal DataReg    : std_logic_vector(DataWidth_c - 1 downto 0);
  signal DataRegIn  : std_logic_vector(DataWidth_c - 1 downto 0);
  signal DataRegEn  : boolean;
  signal DataRegSel : std_logic;

  -- the BramAddrReg is used for computing the read addresses for the BRAMs
  signal BramBaseReg    : std_logic_vector(BramAddrWidth_c - 3 downto 0);
  signal BramBaseRegIn  : std_logic_vector(BramAddrWidth_c - 3 downto 0);
  signal BramBaseRegEn  : boolean;
  signal BramBaseRegSel : std_logic;

  -- actual read address ports for BRAM1 and BRAM2
  signal Bram1RdAddr : std_logic_vector(BramAddrWidth_c - 1 downto 0);
  signal Bram2RdAddr : std_logic_vector(BramAddrWidth_c - 1 downto 0);

  -- selector for BRAM1 read address:
  --      - "00" - a
  --      - "01" - f(a)
  --      - "11" - bias
  signal Bram1RdAddrSel : std_logic_vector(1 downto 0);

  -- selector for BRAM2 read address:
  --      - "00" - f'(a)
  --      - "01" - 1/2*f"(a)
  --      - "11" - weights
  signal Bram2RdAddrSel : std_logic_vector(1 downto 0);

  -- the output register from the DSP
  signal DspOutReg : std_logic_vector(47 downto 0);

begin
  DataRegIn     <= DataIn when DataRegSel = '0' else DspOutReg(DataWidth_c - 1 downto 0);
  BramBaseRegIn <= IdentIn(BramAddrWidth_c - 3 downto 0) when BramBaseRegSel = '0' else DspOutReg(BramAddrWidth_c - 3 downto 0);

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

  BramBaseRegister : process(Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
        BramBaseReg <= (others => '0');
      elsif BramBaseRegEn then
        BramBaseReg <= BramBaseRegIn;
      end if;
    end if;
  end process;

  -- BRAM1 data contents - interleaved a, f(a), and 
  -- bias on locations ending with "11"
  -- /----------\
  -- |    a0    | => ..00
  -- |----------|
  -- |  f(a0)   | => ..01
  -- |----------|
  -- |----------|
  -- |   bias   | => ..11
  -- |----------|
  -- |  [...]   |
  -- |----------|
  -- |   a31    | => ..00
  -- |----------|
  -- |  f(a31)  | => ..01
  -- \----------/

  Bram1RdAddr <= --Bram1BiasAddr_c when Bram1RdAddrSel = "11" else
                 BramBaseReg & Bram1RdAddrSel;

  -- BRAM2 data contents - interleaved f'(a), 1/2*f"(a) and weights
  -- the number of weights depends on the number of inputs
  -- /----------\
  -- |  f'(a0)  | => ..00
  -- |----------|
  -- |1/2f"(a0) | => ..01
  -- |----------|
  -- |----------|
  -- | weight0  | => ..11
  -- |----------|
  -- |  [...]   |
  -- |----------|
  -- | f'(a31)  | => ..00
  -- |----------|
  -- |1/2f"(a31)| => ..01
  -- |----------|
  -- | weight31 | => ..11
  -- |----------|
  -- |  [...]   | => ..11
  -- \----------/

  Bram2RdAddr <= BramBaseReg & Bram2RdAddrSel;

end architecture RTL;
