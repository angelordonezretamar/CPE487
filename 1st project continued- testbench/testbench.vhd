-- Code your testbench here
-- As always, there are other ways this can be done, but this should do the job for our purposes
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is
component mux4to1 is
    Port ( D3,D2,D1,D0 : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           MX_OUT,MX_OUT2 : out STD_LOGIC;
           test,test2: out std_logic_vector (5 downto 0));
end component mux4to1;
-- Any inputs or outputs of your entity should be created as signals here
-- Don't double create CLK if your entity has them too!
signal CLK: std_logic;
signal D3,D2,D1,D0,MX_OUT,MX_OUT2 : STD_LOGIC;
signal sel : STD_LOGIC_VECTOR (1 downto 0);
signal test,test2 : STD_LOGIC_VECTOR (5 downto 0);
-- The following values can be changed as needed if you actually need a longer/shorter simulationTime, slower/faster clock period, etc.
constant period : time := 20 ns;
constant simulationTime : time := 240 ns;
begin

--Change mycomponent to what you changed "mycomponent" to above
--Inside the parentheses, include all ports from your component
whenBundledComponent : entity work.mux4to1(whenBundled) port map(D3,D2,D1,D0,sel,MX_OUT,test);
whenifMuxComponent : entity work.mux4to1(ifMux) port map(D3,D2,D1,D0,sel,MX_OUT2,test2);

--mytestingcomponent: mycomponent port map();

--Generally should keep this part the same as it allows our simulation to have a standardized clock
--It also forces the simulation to end at time "simulationTime"
clk_process: process
begin
CLK <= '0';
wait for period/2;
CLK <= '1';
wait for period/2;
if NOW >= simulationTime then
wait;
end if;
end process clk_process;

inputs_process: process
begin
-- In here, we'd create a sequence of changes to our inputs to test our system
-- This is the main point of the testbench!
-- We could test different inputs to a sequence of gates, different patterns of inputs for a finite state machine, etc.
D3<='0';
D2<='1';
D1<='0';
D0<='X'; --means undefined signal
sel<="00";

wait for period;

sel<="01";

wait for period;

sel<="10";

wait for period;

sel<="11";

wait for period;

sel<="XX"; --testing the catch-all
-- KEEP THIS WAIT STATEMENT! Otherwise your simulation will never complete
wait;
end process inputs_process;
end tb;