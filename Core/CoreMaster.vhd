library ieee;
use ieee.std_logic_1164.all;

use work.PkgUtilities.all;

entity CoreMaster is
  port(
    Clk     : in  std_logic;
    Rst     : in  std_logic;
    
    -- Req: asserted when the Core receives a new request
    -- stays asserted until Ack asserts
    Req     : in  boolean;
    
    -- Ack: asserts when a new request is accepted
    -- stays asserted until Req deasserts
    Ack     : out boolean;
    
    -- Done: asserted when the Core is ready to process
    -- a new command
    Done    : out boolean;
    
    -- Command: the new command that will be executed by the core
    Operation : in  CoreOperation_t
  );
end entity CoreMaster;

architecture RTL of CoreMaster is

  type ControllerState_t is (Idle, Store, Decode, Execute);

  signal CrState, NxState : ControllerState_t;
  signal OperationRegEnable : boolean;
  signal OperationReg : CoreOperation_t;
  signal DoneFromSlave : boolean;
  
begin

  ------------------------
  -- Begin CoreMasterFSM --
  ------------------------
  
  NextState: process (Rst, Clk)
  begin
    if Rst='1' then
      CrState <= Idle;
    elsif rising_edge(Clk) then
      CrState <= NxState;
    end if;
  end process;
  
  Decision: process (CrState, Req, DoneFromSlave)
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
        NxState <= Decode;
          
      when Decode =>
      -- need to identify new command
        NxState <= Execute;
      
      when Execute =>
      -- will execute new command
        if DoneFromSlave then
          NxState <= Idle;
        end if;
    end case;
  end process;  
  
  Output: process (CrState)
  begin
    case CrState is
      when Idle =>
        Done <= true;
        Ack <= false;
        OperationRegEnable <= false;
      when Store =>
      when Decode =>
      when Execute =>
    end case;
  end process;
  
  ------------------------
  -- End CoreMasterFSM --
  ------------------------
  
  OpReg: process (Rst, Clk)
  begin
    if Rst = '1' then
      OperationReg <= NoOperation;
    elsif rising_edge (Clk) then
      if OperationRegEnable then
        OperationReg <= Operation;
      end if;
    end if;
  end process;

end architecture RTL;
