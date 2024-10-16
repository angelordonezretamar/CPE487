-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port (X, CLK, RESET: in std_logic; --we only transition between states on the rising edge of the clock
    Y : out std_logic_vector(2 downto 0); --to accomplish encoding
    Z : out std_logic);
end fsm;
--wanna change it to 11000 to be 5 and require less changes to source code
 architecture fsmMealy1101 of fsm is --mealy so we only need ABCD
 	type state_type is (A, B, C, D, E); --declaring them as like reserved variables for each state
     signal PS, NS : state_type; --present state and next state
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then PS <= A; --asynchronous and active high
         elsif (rising_edge(CLK)) then PS <= NS;
         end if;
   	end process clockAndReset;
 -- From state A, a 1 outputs a 0 and goes to state B
 -- From state A, a 0 outputs a 0 and goes to state A
 -- B: 1/0 -> C
 -- B: 0/0 -> B
 -- C: 1/0 -> B
 -- C: 0/0 -> D
 -- D: 0/0 -> E
 -- D: 1/0 -> A
 -- E: 0/1 -> A
 -- E: 1/0 -> B   
     stateAndOutputLogic : process(PS, X)
     begin
     case PS is
     	when A =>
         	if (X = '1') then Z<='0'; NS <= B; -- 1/0 -> B
             else Z <= '0'; NS <= A; -- 0/0 -> A
             end if;
         when B =>
         	if (X = '1') then Z <= '0'; NS <= C; -- 1/0 -> C
             else Z <= '0'; NS <= B; -- 0/0 -> B
             end if;
         when C =>
         	if (X = '0') then Z <= '0'; NS <= D; -- 0/0 -> D
             else Z <= '0'; NS <= B; -- 1/0 -> B
             end if;
         when D =>
         	if (X = '0') then Z <= '0'; NS <= E; -- 0/0 -> E
             else Z <= '0'; NS <= A; -- D: 1/0 -> A
             end if;
         when E =>
            if (X = '0') then Z <= '1'; NS <= A; -- 0/1 -> A
             else Z <= '0'; NS <= B; -- 1/0 -> B
             end if;
             end case;
     end process stateAndOutputLogic;
    
     with PS select
     Y <= "000" when A,
     	  "001" when B,
          "010" when C,
          "011" when D,
          "111" when E,          
          "000" when others;
 end fsmMealy1101;  