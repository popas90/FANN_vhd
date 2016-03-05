library ieee;
use ieee.std_logic_1164.all;

Library unisim;
use unisim.vcomponents.all;

use work.PkgConfiguration.all;

entity DspBlockWrapper is
  generic(
    -- DspType: supported DSP48 type for the
    -- board in use. Set in PkgConfiguration.vhd
    DspType : Dsp48Type_t := DspConfig_c
  );
  port(

    -- Global clock signal
    Clk : in std_logic;

    -- Global sync reset signal
    Rst : in std_logic;

    -- Mode selector
    -- FIXME reduce size to minimum needed to encode all operations
    OpMode_in : in std_logic_vector(7 downto 0);

    -- Enable signals for DSP registers
    -- ------------------------------
    -- | A | B | C | D | M | P | Op |
    -- ------------------------------
    EnableRegs_in : in std_logic_vector(6 downto 0);

    -- Data in signals
    DataD_in : in std_logic_vector(17 downto 0);
    DataB_in : in std_logic_vector(17 downto 0);
    DataA_in : in std_logic_vector(17 downto 0);
    DataC_in : in std_logic_vector(47 downto 0);

    -- Data out signal
    DataP_out : out std_logic_vector(47 downto 0)

  );
end entity DspBlockWrapper;

architecture rtl of DspBlockWrapper is
  signal SyncRstLoc : std_ulogic;
begin
  Spartan6DSP : if DspType = DspBlock48A1 generate
    DSP48A1_inst : DSP48A1
      generic map(
        A0REG       => 1,               -- First stage A input pipeline register (0/1)
        A1REG       => 0,               -- Second stage A input pipeline register (0/1)
        B0REG       => 1,               -- First stage B input pipeline register (0/1)
        B1REG       => 1,               -- Second stage B input pipeline register (0/1)
        CARRYINREG  => 0,               -- CARRYIN input pipeline register (0/1)
        CARRYINSEL  => "OPMODE5",       -- Specify carry-in source, "CARRYIN" or "OPMODE5"
        CARRYOUTREG => 0,               -- CARRYOUT output pipeline register (0/1)
        CREG        => 1,               -- C input pipeline register (0/1)
        DREG        => 1,               -- D pre-adder input pipeline register (0/1)
        MREG        => 1,               -- M pipeline register (0/1)
        OPMODEREG   => 0,               -- Enable=1/disable=0 OPMODE input pipeline registers
        PREG        => 1,               -- P output pipeline register (0/1)
        RSTTYPE     => "SYNC"           -- Specify reset type, "SYNC" or "ASYNC"
      )
      port map(
        -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
        BCOUT      => open,             -- 18-bit output: B port cascade output
        PCOUT      => open,             -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)

        -- Data Ports: 1-bit (each) output: Data input and output ports
        CARRYOUT   => open,             -- 1-bit output: carry output (if used, connect to CARRYIN pin of another DSP48A1)
        CARRYOUTF  => open,             -- 1-bit output: fabric carry output
        M          => open,             -- 36-bit output: fabric multiplier data output
        P          => DataOutP,          -- 48-bit output: data output

        -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
        PCIN       => (others => '0'),  -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)

        -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
        CLK        => Clk,              -- 1-bit input: clock input
        OPMODE     => OpMode,           -- 8-bit input: operation mode input

        -- Data Ports: 18-bit (each) input: Data input and output ports
        A          => DataInA,          -- 18-bit input: A data input
        B          => DataInB,          -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
        C          => DataInC,          -- 48-bit input: C data input
        CARRYIN    => '0',              -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another DSP48A1)
        D          => DataInD,          -- 18-bit input: D pre-adder data input

        -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
        CEA        => EnaA,             -- 1-bit input: active high clock enable input for A registers
        CEB        => EnaB,             -- 1-bit input: active high clock enable input for B registers
        CEC        => EnaC,             -- 1-bit input: active high clock enable input for C registers
        CECARRYIN  => '0',              -- 1-bit input: active high clock enable input for CARRYIN registers
        CED        => EnaD,             -- 1-bit input: active high clock enable input for D registers
        CEM        => EnaM,             -- 1-bit input: active high clock enable input for multiplier registers
        CEOPMODE   => '0',              -- 1-bit input: active high clock enable input for OPMODE registers
        CEP        => EnaP,             -- 1-bit input: active high clock enable input for P registers
        RSTA       => SyncRstLoc,       -- 1-bit input: reset input for A pipeline registers
        RSTB       => SyncRstLoc,       -- 1-bit input: reset input for B pipeline registers
        RSTC       => SyncRstLoc,       -- 1-bit input: reset input for C pipeline registers
        RSTCARRYIN => '0',              -- 1-bit input: reset input for CARRYIN pipeline registers
        RSTD       => SyncRstLoc,       -- 1-bit input: reset input for D pipeline registers
        RSTM       => SyncRstLoc,       -- 1-bit input: reset input for M pipeline registers
        RSTOPMODE  => SyncRstLoc,              -- 1-bit input: reset input for OPMODE pipeline registers
        RSTP       => SyncRstLoc        -- 1-bit input: reset input for P pipeline registers
      );

  end generate Spartan6DSP;

  SyncRstLoc <= SyncRst or Rst;

end architecture rtl;
