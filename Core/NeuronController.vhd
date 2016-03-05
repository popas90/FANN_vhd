library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PkgConfiguration.all;

entity NeuronController is
  port(

    -- Global clock signal
    Clk               : in  std_logic;

    -- Sync reset signal
    Rst               : in  std_logic;

    -- Control signals
    -- FIXME determine correct size
    Control_in : in std_logic_vector(5 downto 0);

    -- Load port for the data input counter
    NoOfInputs_in : in std_logic_vector(15 downto 0);

    -- Validates the input data. Used for counting inputs received
    InputValid_in     : in  std_logic;

    -- Output data is ready, after computing the activation function
    OutputValid_out   : out std_logic;

    -- The neuron is ready to receive a new data point
    ReadyForInput_out : out std_logic;

    -- Flags going to DSP block
    DspFlags_out      : out std_logic_vector
  );
end entity NeuronController;

architecture rtl of NeuronController is
  type NeuronFSM_t is (Idle, Act1, Act2, Act3, Act4, Act5, Act6, Act7);
  signal CrState, NxState : NeuronFSM_t := Idle;

  signal NoOfInputsReg : std_logic_vector(15 downto 0) := (others => '0');
  signal ReadyForInput : std_logic;

  -- When in Linear stage, this signal keeps track of data validity
  -- in all pipeline stages. The width must change according to the
  -- number of pipeline stages used
  signal LinearValidChain : std_logic_vector(5 downto 0);
  signal InputValidQual : std_logic;
  signal SetNoOfInputs : std_logic;
  signal CountInputsReg : std_logic_vector(15 downto 0) := (others => '0');

begin

  ValidChain: process(Clk)
  begin
    if rising_edge(Clk) then
      if (Rst = '1') then
        LinearValidChain <= (others => '0');
      elsif
        LinearValidChain <= InputValidQual & LinearValidChain(LinearValidChain'left downto 1);
      end if;
    end if;
  end process ValidChain;

  InputValidQual <= InputValid_in and ReadyForInput;
  ReadyForInput_out <= ReadyForInput;

  -- Store expected number of data points to receive
  NumberOfInputs: process(Clk)
  begin
    if rising_edge(Clk) then
      if (Rst = '1') then
        NoOfInputsReg <= (others => '0');
      elsif (SetNoOfInputs = '1') then
        -- load new value to the counter
        -- like flushing the pipeline, because previous data is discarded
          NoOfInputsReg <= NoOfInputs_in;
      end if;
    end if;
  end process NumberOfInputs;

  -- Count received data points
  CountInputs: process (Clk)
  begin
    if rising_edge(Clk) then
      if (Rst = '1') then
        CountInputsReg <= (others => '0');
      elsif (LoadNoOfInputsToCount = '1') then
        CountInputsReg <= NoOfInputsReg;
      elsif (InputValidQual = '1') then
        CountInputsReg <= std_logic_vector(unsigned(CountInputsReg) - 1);
      end if;
    end if;
  end process CountInputs;

  -- FSM --
  Decision : process(Clk)
  begin
    NxState <= CrState;

    case CrState is
      when Idle =>
        if (NoOfInputsReg = (others => '0')) then
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
  end process Decision;

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

  Output : process(CrState)
  begin
    case CrState is
      when Idle =>
        ReadyForInput   <= '1';
        OutputValid_out <= '0';
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
