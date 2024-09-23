-- Testbench for 4-bit Ripple Carry Adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_tb is
end adder_tb;

architecture behav of adder_tb is
  -- Declaration of the ripple carry adder component
  component ripple_carry_adder
    Port (
      a    : in  std_logic_vector(3 downto 0);
      b    : in  std_logic_vector(3 downto 0);
      cin  : in  std_logic;
      sum  : out std_logic_vector(3 downto 0);
      cout : out std_logic
    );
  end component;

  -- Signals for inputs and outputs
  signal a, b : std_logic_vector(3 downto 0);
  signal cin : std_logic;
  signal sum : std_logic_vector(3 downto 0);
  signal cout : std_logic;

begin
  -- Instantiate the 4-bit ripple carry adder
  adder_inst: ripple_carry_adder port map (
    a    => a,
    b    => b,
    cin  => cin,
    sum  => sum,
    cout => cout
  );

  -- Test process
  process
  begin
    -- Apply test patterns
    a <= "0000"; b <= "0000"; cin <= '0'; wait for 10 ns;
    assert (sum = "0000" and cout = '0') report "Test case 1 failed" severity error;

    a <= "0001"; b <= "0001"; cin <= '0'; wait for 10 ns;
    assert (sum = "0010" and cout = '0') report "Test case 2 failed" severity error;

    a <= "0110"; b <= "0011"; cin <= '0'; wait for 10 ns;
    assert (sum = "1001" and cout = '0') report "Test case 3 failed" severity error;

    a <= "1111"; b <= "1111"; cin <= '0'; wait for 10 ns;
    assert (sum = "1110" and cout = '1') report "Test case 4 failed" severity error;

    a <= "1111"; b <= "1111"; cin <= '1'; wait for 10 ns;
    assert (sum = "1111" and cout = '1') report "Test case 5 failed" severity error;

    -- End simulation
    assert false report "End of test" severity note;
    wait;
  end process;

end behav;