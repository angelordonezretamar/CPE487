----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/10/2024 12:52:59 PM
-- Design Name: 
-- Module Name: gates - DataFlowConsolidated
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gates is
    Port ( L,M,N : in STD_LOGIC;
           F3 : out STD_LOGIC);
end gates;

architecture DataFlowConsolidated of gates is

begin

F3 <= (NOT(L) AND NOT(M) AND N) OR (L AND M);

end DataFlowConsolidated;

--we add signals to see intermediate outputs like A1 and A2 for the outputs after each AND gate
architecture DataFlowSignals of gates is
signal A1, A2 : std_logic;
begin

A1 <= (NOT(L) AND NOT(M) AND N);
A2 <= (L AND M);
F3 <= A1 OR A2;

end DataFlowSignals;

--here we want to use the gates logic to assign values
architecture DataFlowSelect of gates is

begin
with (NOT(L) AND NOT(M) AND N) OR (L AND M) select
F3 <= '1' when '1',
      '0' when '0',
      '0' when others;
--others is a nice catch-all to use just in case

end DataFlowSelect;
