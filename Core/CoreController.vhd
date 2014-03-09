library ieee;
use ieee.std_logic_1164.all;

use work.PkgUtilities.all;

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
    Operation : in  CoreOperation_t
  );
end entity CoreController;

architecture RTL of CoreController is
  type ControllerState_t is (Idle, Store, Decode, LinearSt1);

  signal CrState, NxState   : ControllerState_t;
  signal OperationRegEnable : boolean;
  signal OperationReg       : CoreOperation_t;
  signal NoOfInputsReg      : integer;

begin

  ------------------------
  -- Begin CoreControllerFSM --
  ------------------------

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

  ------------------------
  -- End CoreControllerFSM --
  ------------------------

  OpReg : process(Rst, Clk)
  begin
    if Rst = '1' then
      OperationReg <= NoOperation;
    elsif rising_edge(Clk) then
      if OperationRegEnable then
        OperationReg <= Operation;
      end if;
    end if;
  end process;

end architecture RTL;
