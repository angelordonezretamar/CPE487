-- 4-bit Ripple Carry Adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- for arithmetic operations (optional)
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- for arithmetic operations (optional)

entity ripple_carry_adder is
  Port (
    a    : in  std_logic_vector(3 downto 0);
    b    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end ripple_carry_adder;

architecture behavior of ripple_carry_adder is
  signal carry : std_logic_vector(3 downto 0);  -- Internal carry signals
begin
  -- Full adder logic for each bit
  sum(0) <= a(0) xor b(0) xor cin;
  carry(0) <= (a(0) and b(0)) or (a(0) and cin) or (b(0) and cin);

  sum(1) <= a(1) xor b(1) xor carry(0);
  carry(1) <= (a(1) and b(1)) or (a(1) and carry(0)) or (b(1) and carry(0));

  sum(2) <= a(2) xor b(2) xor carry(1);
  carry(2) <= (a(2) and b(2)) or (a(2) and carry(1)) or (b(2) and carry(1));

  sum(3) <= a(3) xor b(3) xor carry(2);
  cout <= (a(3) and b(3)) or (a(3) and carry(2)) or (b(3) and carry(2));
end behavior;