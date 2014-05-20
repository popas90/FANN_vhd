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
--
-- DSP Schematic:
-- 
--              /-----\ 
-- PreAdderIn-->|PRE- |
--              |ADDER|            /----\ 
-- PreAdderIn-->|     |--MultIn0-->|    |               /-----\
--              \-----/            |MULT|--MultResult-->|     |  
-- MultIn1 ----------------------->|    |               |POST-|
--                                 \----/               |ADDER|--PostAdderResult-->
-- PostAdderIn1 --------------------------------------->|(ALU)|
--                                                      \-----/   
-- 
-------------------------------------------------


entity CoreController is
  port(

    -- Global clock signal
        Clk         : in  std_logic;

    -- Global sync reset signal
    -- This signal is used only for the main FSM
    -- The FSM is responsible for resetting the local
    -- resources (counters, shift registers, etc).
        Rst         : in  boolean;

    -- NeuronID : the id for the currently
    -- emulated neuron
        NeuronID    : in  integer;

    -- Start: control signal that starts the Core FSM
        Start : in boolean;

    -- InputValid: asserted when new data is
    -- sent to the Core
        InputValid  : in  boolean;

    -- DataCount: stores the number of inputs
    -- accepted by the Core
        InputCountOut  : out ShortNatural_t;

    -- OutputValid: asserts when the Core has produced a 
    -- new output data point
        OutputValid : out boolean;

    -- Enable signals for RAM blocks
        MemoryA_RdEn : out boolean;
        MemoryB_RdEn : out boolean;

    -- Enable signals for DSP block registers
    -- DspRegsEnable(0) -> InputRegEn
    -- DspRegsEnable(1) -> PreAdderIn0RegEn
    -- DspRegsEnable(2) -> PreAdderIn1BRegEn
    -- DspRegsEnable(3) -> MultIn1RegEn
    -- DspRegsEnable(4) -> PostAdderIn1RegEn
    -- DspRegsEnable(5) -> MultResultRegEn
    -- DspRegsEnable(6) -> PostAdderResultRegEn
        DspRegsEnable : out BooleanArray_t(6 downto 0)

  -- OpMode signals for the DSP components
  -- OpMode(0) -> PreAdder addition/subtraction
  -- OpMode(1) ->
      );
end entity CoreController;

architecture RTL of CoreController is
  type ControllerState_t is (Idle, Linear, ActivFunc, OutputRes);
  constant ValidStages : natural := 5;

  signal CrState, NxState : ControllerState_t := Idle;

  signal LinearValidChain    : BooleanArray_t(1 to ValidStages) := (others => false);
  signal LinearValidChainRst : boolean;
  signal LinearValidChainEn  : boolean;

  signal InputCountEn  : boolean;
  signal InputCountRst : boolean;
  signal InputCount : ShortNatural_t := 0;

  signal ActivFuncCount : std_logic_vector(2 downto 0) := (others => '0');
  signal ActivFuncCountEn : boolean;
  signal ActivFuncCountRst : boolean;

begin

  ------------------------
  -- Begin CoreControllerFSM --
  ------------------------

  CoreFSM : block
  begin
    NextState : process(Clk)
    begin
      if rising_edge(Clk) then
        if Rst then
          CrState <= Idle;
        else
          CrState <= NxState;
        end if;
      end if;
    end process NextState;

    Decision : process(CrState, InputCount, NeuronID, Start)
    begin
      NxState <= CrState;

      case CrState is
        when Idle =>
          -- new data is available
          if Start then
            NxState <= Linear;
          end if;

        when Linear =>
          -- compute linear part of the neuron
          if InputCount >= NoOfInputs_c(NeuronID) then
            NxState <= ActivFunc;
          end if;

        when ActivFunc =>
        -- compute activation function

        when OutputRes =>
      -- output the activation function result

      end case;
    end process Decision;

    Output : block
    begin
      -- Local resets
      LinearValidChainRst <= false when CrState = Linear else true;
      InputCountRst <= false when CrState = Linear else true;
      ActivFuncCountRst <= false when CrState = ActivFunc else true;
      -- Control signals to the DSP block
      DspRegsEnable(0) <= InputValid when CrState = Linear else false;
      MemoryA_RdEn <= LinearValidChain(1) when CrState = Linear else false;
      DspRegsEnable(1) <= LinearValidChain(2) when CrState = Linear else false;
      DspRegsEnable(2) <= LinearValidChain(3) when CrState = Linear else false;
      DspRegsEnable(3) <= LinearValidChain(3) when CrState = Linear else false;
      DspRegsEnable(4) <= false when CrState = Linear else false;
      DspRegsEnable(5) <= LinearValidChain(4) when CrState = Linear else false;
      DspRegsEnable(6) <= LinearValidChain(5) when CrState = Linear else false;
      -- OpModeRegEn <= 
    end block Output;
  end block CoreFSM;

      ------------------------
      -- End CoreControllerFSM --
      ------------------------

  InputCountOut <= InputCount;

  InputCnt : process(Clk)
  begin
    if rising_edge(Clk) then
      if InputCountRst then
        InputCount <= 0;
      elsif InputCountEn then
        InputCount <= InputCount + 1;
      end if;
    end if;
  end process;

  ChainShiftReg : process(Clk)
  begin
    if rising_edge(Clk) then
      if LinearValidChainRst then
        LinearValidChain <= (others => false);
      elsif LinearValidChainEn then
        LinearValidChain <= InputValid & LinearValidChain(1 to ValidStages - 1);
      end if;
    end if;
  end process;

  ActivationCycleCount: process(Clk)
  begin
    if rising_edge(Clk) then
      if ActivFuncCountRst then
        ActivFuncCount <= (others => '0');
      elsif ActivFuncCountEn then
        ActivFuncCount <= ActivFuncCount + 1;
      end if;
    end if; 
  end process;

end architecture RTL;
