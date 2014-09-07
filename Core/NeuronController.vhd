library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;

entity NeuronController is
  port(

    -- Global clock signal
    Clk           : in  std_logic;

    -- Sync reset signal
    Rst           : in  std_logic;

    -- Enable flag for validating the NoOfInputs signal
    SetNoOfInputs : in  std_logic;

    -- Number of inputs expected before computing the activation fct
    NoOfInputs    : in  std_logic_vector(15 downto 0);

    -- Validates the input data. Used for counting inputs received
    InputValid    : in  std_logic;

    -- Output data is ready, after computing the activation fct
    OutputValid   : out std_logic;

    -- The neuron is ready to receive a new data point
    ReadyForInput : out std_logic
  );
end entity NeuronController;

architecture rtl of NeuronController is
  type NeuronFSM_t is (Idle, Lin1, Lin2, Lin3, Act1, Act2, Act3, Act4, Act5, Act6, Act7);
  signal CrState, NxState : NeuronFSM_t := Idle;

  signal NoOfInputsReg       : std_logic_vector(15 downto 0);
  signal CountReceivedReg : std_logic_vector(15 downto 0);

begin

  -- NeuronCore FSM --
  Decision : process(Clk)
  begin
    NxState <= CrState;

    case CrState is
      when Idle =>
        if (InputValid = '1') then
          NxState <= Lin1;
        else
          NxState <= Idle;
        end if;

      when Lin1 =>
        NxState <= Lin2;

      when Lin2 =>
        NxState <= Lin3;

      when Lin3 =>
        if (CountReceivedReg = 0) then
          NxState <= Act1;
        else
          NxState <= Idle;
        end if;

      when Act1 =>
        NxState <= Act2;

      when Act2 =>
        NxState <= Act3;

      when Act3 =>
        NxState <= Act4;

      when Act4 =>
        NxState <= Act5;

      when Act5 =>
        NxState <= Act6;

      when Act6 =>
        NxState <= Act7;

      when Act7 =>
        NxState <= Idle;

    end case;
  end process NextState;

  NextState : process(Clk)
  begin
    if rising_edge(Clk) then
      if (Rst = '1') then
        CrState <= Idle;
      else
        CrState <= NxState;
      end if;
    end if;
  end process NextState;

  Output: process (CrState)
  begin
    case CrState is 
      when Idle =>
        
      when Lin1 =>
        null;
      when Lin2 =>
        null;
      when Lin3 =>
        null;
      when Act1 =>
        null;
      when Act2 =>
        null;
      when Act3 =>
        null;
      when Act4 =>
        null;
      when Act5 =>
        null;
      when Act6 =>
        null;
      when Act7 =>
        null;
    end case;
  end process Output;
    
    

end architecture rtl;
	
