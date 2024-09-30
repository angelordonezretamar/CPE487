--  https://electronicstopper.blogspot.com/2017/07/t-flip-flop-in-vhdl-with-testbench.html
library ieee;
use ieee.std_logic_1164.all;

entity TFF is
port( T: in std_logic;
    clk: in std_logic;
    rst: in std_logic;
    set: in std_logic;
      Q: out std_logic);
end TFF;

architecture behavioral of TFF is
    signal t_tmp: std_logic := '0'; 
begin
process(rst,clk,T, set)
begin
    if (set = '1') then
        t_tmp <= '1';
    elsif (rst = '1') then
        t_tmp <= '0';
    elsif(rising_edge(clk)) then
        if (T='1') then
            t_tmp <= not t_tmp;
        end if;
    end if;
end process;
Q <= t_tmp;
end behavioral;
