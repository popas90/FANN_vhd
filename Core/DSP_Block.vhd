
--   DSP48A1   : In order to incorporate this function into the design,
--    VHDL     : the following instance declaration needs to be placed
--  instance   : in the body of the design code.  The instance name
-- declaration : (DSP48A1_inst) and/or the port declarations after the
--    code     : "=>" declaration maybe changed to properly reference and
--             : connect this function to the design.  All inputs and outputs
--             : must be connected.

--   Library   : In addition to adding the instance declaration, a use
-- declaration : statement for the UNISIM.vcomponents library needs to be
--     for     : added before the entity declaration.  This library
--   Xilinx    : contains the component declarations for all Xilinx
-- primitives  : primitives and points to the models that will be used
--             : for simulation.

--  Copy the following two statements and paste them before the
--  Entity declaration, unless they already exist.

Library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

entity DSP_Block is
  port(
    clk : in  std_logic;
    sw  : in  std_logic_vector(7 downto 0);
    led : out std_logic_vector(7 downto 0)
  );
end entity DSP_Block;

architecture rtl of DSP_Block is
  signal BCOUT      : std_logic_vector(17 downto 0);
  signal PCOUT      : std_logic_vector(47 downto 0);
  signal CARRYOUT   : std_ulogic;
  signal CARRYOUTF  : std_ulogic;
  signal M          : std_logic_vector(35 downto 0);
  signal P          : std_logic_vector(47 downto 0);
  signal PCIN       : std_logic_vector(47 downto 0);
  signal OPMODE     : std_logic_vector(7 downto 0);
  signal A          : std_logic_vector(17 downto 0);
  signal B          : std_logic_vector(17 downto 0);
  signal C          : std_logic_vector(47 downto 0);
  signal CARRYIN    : std_ulogic;
  signal D          : std_logic_vector(17 downto 0);
  signal CEA        : std_ulogic := '1';
  signal CEB        : std_ulogic := '1';
  signal CEC        : std_ulogic := '1';
  signal CECARRYIN  : std_ulogic := '0';
  signal CED        : std_ulogic := '1';
  signal CEM        : std_ulogic := '1';
  signal CEOPMODE   : std_ulogic := '0';
  signal CEP        : std_ulogic := '1';
  signal RSTA       : std_ulogic := '0';
  signal RSTB       : std_ulogic := '0';
  signal RSTC       : std_ulogic := '0';
  signal RSTCARRYIN : std_ulogic := '0';
  signal RSTD       : std_ulogic := '0';
  signal RSTM       : std_ulogic := '0';
  signal RSTOPMODE  : std_ulogic := '0';
  signal RSTP       : std_ulogic := '0';

begin

  -- DSP48A1: 48-bit Multi-Functional Arithmetic Block Spartan-6
  -- Xilinx HDL Language Template, version 14.6

  DSP48A1_inst : DSP48A1
    generic map(
      A0REG       => 1,                 -- First stage A input pipeline register (0/1)
      A1REG       => 0,                 -- Second stage A input pipeline register (0/1)
      B0REG       => 1,                 -- First stage B input pipeline register (0/1)
      B1REG       => 1,                 -- Second stage B input pipeline register (0/1)
      CARRYINREG  => 0,                 -- CARRYIN input pipeline register (0/1)
      CARRYINSEL  => "OPMODE5",         -- Specify carry-in source, "CARRYIN" or "OPMODE5" 
      CARRYOUTREG => 0,                 -- CARRYOUT output pipeline register (0/1)
      CREG        => 1,                 -- C input pipeline register (0/1)
      DREG        => 1,                 -- D pre-adder input pipeline register (0/1)
      MREG        => 1,                 -- M pipeline register (0/1)
      OPMODEREG   => 0,                 -- Enable=1/disable=0 OPMODE input pipeline registers
      PREG        => 1,                 -- P output pipeline register (0/1)
      RSTTYPE     => "SYNC"             -- Specify reset type, "SYNC" or "ASYNC" 
    )
    port map(
      -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
      BCOUT      => BCOUT,              -- 18-bit output: B port cascade output
      PCOUT      => PCOUT,              -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)

      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT   => CARRYOUT,           -- 1-bit output: carry output (if used, connect to CARRYIN pin of another DSP48A1)
      CARRYOUTF  => CARRYOUTF,          -- 1-bit output: fabric carry output
      M          => M,                  -- 36-bit output: fabric multiplier data output
      P          => P,                  -- 48-bit output: data output

      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN       => PCIN,               -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)

      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK        => clk,                -- 1-bit input: clock input
      OPMODE     => OPMODE,             -- 8-bit input: operation mode input

      -- Data Ports: 18-bit (each) input: Data input and output ports
      A          => A,                  -- 18-bit input: A data input
      B          => B,                  -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C          => C,                  -- 48-bit input: C data input
      CARRYIN    => CARRYIN,            -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another DSP48A1)
      D          => D,                  -- 18-bit input: D pre-adder data input

      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA        => CEA,                -- 1-bit input: active high clock enable input for A registers
      CEB        => CEB,                -- 1-bit input: active high clock enable input for B registers
      CEC        => CEC,                -- 1-bit input: active high clock enable input for C registers
      CECARRYIN  => CECARRYIN,          -- 1-bit input: active high clock enable input for CARRYIN registers
      CED        => CED,                -- 1-bit input: active high clock enable input for D registers
      CEM        => CEM,                -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE   => CEOPMODE,           -- 1-bit input: active high clock enable input for OPMODE registers
      CEP        => CEP,                -- 1-bit input: active high clock enable input for P registers
      RSTA       => RSTA,               -- 1-bit input: reset input for A pipeline registers
      RSTB       => RSTB,               -- 1-bit input: reset input for B pipeline registers
      RSTC       => RSTC,               -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => RSTCARRYIN,         -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD       => RSTD,               -- 1-bit input: reset input for D pipeline registers
      RSTM       => RSTM,               -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE  => RSTOPMODE,          -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP       => RSTP                -- 1-bit input: reset input for P pipeline registers
    );
  -- End of DSP48A1_inst instantiation


  -- DSP48A1 configuration --

  -- Post-Adder/Subtracter operation:
  -- 	0 - addition
  -- 	1 - subtraction
  OPMODE(7) <= '0';

  -- Pre-Adder/Subtracter operation:
  -- 	0 - addition
  -- 	1 - subtraction
  OPMODE(6) <= '1';

  -- Forces a value on the carry input of the carry-in register (CYI) to the post-adder.
  -- Only applicable when CARRYINSEL = OPMODE5
  OPMODE(5) <= '0';

  -- Specifies the use of the pre-adder/subtracter
  -- 	0 - bypass pre-adder and supply data on port B directly to the multiplier
  -- 	1 - use pre-adder and feed result into multiplier
  OPMODE(4) <= '1';

  -- Specifies the source of the Z input to the post-adder/subtracter
  -- 	0 - place all zeros (the multiplier result goes directly to P)
  -- 	1 - use PCIN
  --   2 - use P
  -- 	3 - use C
  OPMODE(3 downto 2) <= "11";

  -- Specifies the source of the X input to the post-adder/subtracter
  -- 	0 - place all zeros
  --   1 - use multiplier result
  --   2 - use P
  --   3 - use the concatenated D, B, A input signals
  OPMODE(1 downto 0) <= "01";

  D <= "00000000000000" & sw(7 downto 4);
  A <= "00000000000000" & sw(3 downto 0);
  C <= x"000000000003";

  led <= P(7 downto 0);

end architecture;
				