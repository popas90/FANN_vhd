library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PkgUtilities.all;
use work.PkgComponents.all;

entity tb_LinearController is
end entity tb_LinearController;

architecture test of tb_LinearController is
  constant ClkHalfPeriod_c : time := 10 ns;
  constant NoOfInputs : ShortNatural_t := 8;
  signal Clk : std_logic := '0';
  signal SyncRst, InputValid, OutputValid : boolean := true;
  signal OutputValidAll : boolean := false;
  signal StopSim : boolean := false;
  signal Cnt, CycleCnt : natural := 0;
begin

  Clk <= not Clk after ClkHalfPeriod_c when not StopSim else '0';

  DUT: LinearController
    generic map (
      NoOfInputs_g => NoOfInputs)
    port map (
      Clk => Clk,
      SyncRst => SyncRst,
      InputValid_in => InputValid,
      OutputValid_out => OutputValid);

  -- Main stimulus process
  MainProc: process
  begin
    SyncRst <= true;
    ClkWaitRising(Clk, 2);
    SyncRst <= false;

    -- Write all 8 elements in burst mode
    InputValid <= true;
    ClkWaitRising(Clk, NoOfInputs);
    InputValid <= false;
    ClkWaitRising(Clk, 6);

    -- Make sure OutputValid was asserted at least once in the testbench run
    assert OutputValidAll
      report "OutputValid was never asserted"
      severity error;

    report "TEST PASSED";
    StopSim <= true;
    wait;

  end process;

  -- Counter process for incoming data points
  Counters: process(Clk)
  begin
    if rising_edge(Clk) then
      if Cnt mod NoOfInputs = 0 then
        CycleCnt <= CycleCnt + 1;
      else
        CycleCnt <= 0;
      end if;
      if InputValid then
        Cnt <= Cnt + 1;
      end if;
    end if;
  end process;

  -- Checker process for Output Valid
  OutputValidChecker: process(Clk)
  begin
    if falling_edge(Clk) then
      OutputValidAll <= OutputValidAll or OutputValid;
      if CycleCnt = 4 then
        assert OutputValid
          report "OutputValid should be asserted"
          severity error;
      else
        assert not OutputValid
          report "OutputValid should be deasserted"
          severity error;
      end if;
    end if;
  end process;

end architecture test;
