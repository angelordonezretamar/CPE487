----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 09/10/2024 01:30:01 PM
-- Design Name:
-- Module Name: mux4to1 - whenBundled
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
entity mux4to1 is
Port ( D3,D2,D1,D0 : in STD_LOGIC;
sel : in STD_LOGIC_VECTOR (1 downto 0);
mx_out : out STD_LOGIC;
test : out std_logic_vector(5 downto 0));
end mux4to1;
architecture whenBundled of mux4to1 is
begin
MX_OUT <= D3 when SEL="11" else
D2 when SEL="10" else
D1 when SEL="01" else
d0 WHEN sEl="00" ELSE
'0';
test <= "00"&X"0";
end whenBundled;
architecture whenBits of mux4to1 is
signal D : std_logic_vector(3 downto 0);
begin
D <= D3 & D2 & D1 & D0;
MX_OUT <= D(3) when SEL(1) = '1' and SEL(0) = '1' else
D(2) when SEL(1) = '1' and SEL(0) = '0' else
D(1) when SEL(1) = '0' and SEL(0) = '1' else
D(0) when SEL(1) = '0' and SEL(0) = '0' else
'0';
test <= "000000";
end whenBits;
architecture ifMux of mux4to1 is
begin
ifProcess : process(SEL) is
begin
if SEL = "11" then
MX_OUT <= D3;
elsif SEL = "10" then
MX_OUT <= D2;
elsif SEL = "01" then
MX_OUT <= D1;
elsif SEL = "00" then
MX_OUT <= D0;
else MX_OUT <= '0';
end if;
end process;
test <= "000000";
end ifMux;
