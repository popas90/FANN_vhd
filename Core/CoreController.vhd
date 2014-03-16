library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;
use work.PkgConfiguration.all;

-------------------------------------------------
-------------- THEORY OF OPERATION --------------
-------------------------------------------------
-- The CoreController manages the DSP48 resource
-- of the PE. If the TrainingFlag is asserted,
-- the Core operates in Learning mode.
-- TODO explain Learning mode
-- If the TrainingFlag is deasserted, then
-- the Core operates in Forward Propagation mode.
--
-- Depending on the neuron currently emulated by
-- the PE, the Core expects a specific number of
-- inputs. Until it receives the inputs, it will
-- keep ReadyForInput asserted. A new input is
-- validated by the InputValid flag. The data
-- input is stored and then sent to the linear
-- execution pipeline.
--
-- When the last expected input is processed,
-- the core launches the activation function FSM.
-- For the accumulated result, it will compute
-- the activation function. This result is sent
-- to the Router, and then to the PEs waiting 
-- for this particular result. 
-------------------------------------------------


entity CoreController is
  port(

    -- Global clock signal
    Clk           : in  std_logic;

    -- Global async reset signal
    Rst           : in  std_logic;

    -- NeuronID : the id for the currently
    -- emulated neuron
    NeuronID        : in  integer;

    -- InputValid: asserted when new data is
    -- sent to the Core
    InputValid    : in  boolean;

    -- DataCount: stores the number of inputs
    -- accepted by the Core
    InputCount : out ShortNatural_t;

    -- OutputValid: asserts when the Core has produced a 
    -- new output data point
    OutputValid   : out boolean;
    
    -- ValidChain: a shift register used for validating
    -- data in the linear pipeline of the core
    ValidChain : out BooleanArray_t(1 to ValidStages)


  );
end entity CoreController;

architecture RTL of CoreController is
  type ControllerState_t is (Idle, Linear, ActFunc, OutputRes);

  signal CrState, NxState : ControllerState_t;

  signal ValidChainLoc         : BooleanArray_t(1 to ValidStages);
  signal ValidChainRst      : boolean;
  signal ValidChainEn       : boolean;
  
  signal InputCountEn : boolean;
  signal InputCountRst : boolean;
  signal InputCountLoc : ShortNatural_t := 0;

begin

  ------------------------
  -- Begin CoreControllerFSM --
  ------------------------

  CoreFSM : block
  begin
    NextState : process(Rst, Clk)
    begin
      if Rst = '1' then
        CrState <= Idle;
      elsif rising_edge(Clk) then
        CrState <= NxState;
      end if;
    end process;

    Decision : process(CrState, InputValid, InputCountLoc, NeuronID)
    begin
      NxState <= CrState;

      case CrState is
        when Idle =>
          -- new data is available
          if InputValid then
            NxState <= Linear;
          end if;

        when Linear =>
          -- compute linear part of the neuron
          if InputCountLoc >= NoOfInputs(NeuronID) then
            NxState <= ActFunc;
          end if;

        when ActFunc =>
          -- compute activation function

        when OutputRes =>
          -- output the activation function result
          
      end case;
    end process;

    Output : block
    begin

    end block Output;
  end block CoreFSM;

  ------------------------
  -- End CoreControllerFSM --
  ------------------------
  
  InputCount <= InputCountLoc;

  InputCnt : process(Rst, Clk)
  begin
    if Rst = '1' then
      InputCountLoc <= 0;
    elsif rising_edge(Clk) then
      if InputCountRst then
        InputCountLoc <= 0;
      elsif InputCountEn then
        InputCountLoc <= InputCountLoc + 1;
      end if;
    end if;
  end process;
  
  ValidChain <= ValidChainLoc;

  ChainShiftReg : process(Rst, Clk)
  begin
    if Rst = '1' then
      ValidChainLoc <= (others => false);
    elsif rising_edge(Clk) then
      if ValidChainRst then
        ValidChainLoc <= (others => false);
      elsif ValidChainEn then
        ValidChainLoc <= InputValid & ValidChainLoc(1 to ValidStages - 1);
      end if;
    end if;
  end process;

end architecture RTL;
