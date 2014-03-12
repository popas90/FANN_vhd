library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgUtilities.all;
use work.PkgConfiguration.all;

entity CoreController is
  port(

    -- Global clock signal
    Clk       : in  std_logic;

    -- Global reset signal
    Rst       : in  std_logic;

    -- Req: asserted when the Core receives a new request
    -- stays asserted until Ack asserts
    Req       : in  boolean;

    -- Ack: asserts when a new request is accepted
    -- stays asserted until Req deasserts
    Ack       : out boolean;

    -- Done: asserted when the Core is ready to process
    -- a new command
    Done      : out boolean;

    -- Command: the new command that will be executed by the core
    Operation : in  CoreOperation_t;

    -- Data input port
    DataIn    : in  std_logic_vector(DataWidth - 1 downto 0)
  );
end entity CoreController;

architecture RTL of CoreController is
  type ControllerState_t is (Idle, Store, Decode, LinearSt1);
  constant EnableStages    : natural                           := 5;
  constant ZeroEnableChain : BooleanArray_t(1 to EnableStages) := (others => false);

  signal CrState, NxState : ControllerState_t;

  signal OperationRegEn : boolean;
  signal OperationReg   : CoreOperation_t := NoOperation;

  signal NoOfInputsReg    : integer := 0;
  signal NoOfInputsRegEn  : boolean;
  signal NoOfInputsRegRst : boolean;

  signal EnableChain         : BooleanArray_t(1 to EnableStages);
  signal EnableChainRst      : boolean;
  signal EnableChainEn       : boolean;
  signal EnableChainSerialIn : boolean;
  
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

    Decision : process(CrState, Req, OperationReg)
    begin
      NxState <= CrState;

      case CrState is
        when Idle =>
          -- ready to accept a new command
          if Req then
            NxState <= Store;
          end if;

        when Store =>
          -- new command issued; will store command
          if not Req then
            NxState <= Decode;
          end if;

        when Decode =>
          -- need to identify new command
          if OperationReg = ForwardPass then
            NxState <= LinearSt1;
          --        elsif OperationReg = BackwardPass then
          --          NxState <= BkPassState1;
          end if;

        when LinearSt1 =>
      end case;
    end process;

    Output : block
    begin
      Done <= true when CrState = Idle else false;
      Ack  <= true when CrState = Store else false;
    end block Output;
  end block CoreFSM;

  ------------------------
  -- End CoreControllerFSM --
  ------------------------

  OpReg : process(Rst, Clk)
  begin
    if Rst = '1' then
      OperationReg <= NoOperation;
    elsif rising_edge(Clk) then
      if OperationRegEn then
        OperationReg <= Operation;
      end if;
    end if;
  end process;

  NumberOfInputsReg : process(Rst, Clk)
  begin
    if Rst = '1' then
      NoOfInputsReg <= 0;
    elsif rising_edge(Clk) then
      if NoOfInputsRegRst then
        NoOfInputsReg <= 0;
      elsif NoOfInputsRegEn then
        NoOfInputsReg <= NoOfInputsReg + 1;
      end if;
    end if;
  end process;

  EnChainShiftReg : process(Rst, Clk)
  begin
    if Rst = '1' then
      EnableChain <= ZeroEnableChain;
    elsif rising_edge(Clk) then
      if EnableChainRst then
        EnableChain <= ZeroEnableChain;
      elsif EnableChainEn then
        EnableChainRst <= EnableChainSerialIn & EnableChain(1 to EnableStages - 1);
      end if;
    end if;
  end process;

end architecture RTL;
