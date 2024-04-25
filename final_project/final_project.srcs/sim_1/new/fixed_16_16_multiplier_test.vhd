library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fixed_16_16_multiplier_test is
--  Port ( );
end fixed_16_16_multiplier_test;

architecture Behavioral of fixed_16_16_multiplier_test is
component clock_div_100MHz_to_25_175_MHz is
port( 
clk,reset: in std_logic;
clock_out: out std_logic
);
end component;
signal clk_in : std_logic;
signal clk_out : std_logic;
signal reset : std_logic;
begin
DUT : clock_div_100MHz_to_25_175_MHz port map(
    reset => reset,
    clk => clk_in,
    clock_out => clk_out
);

test: process
begin
    reset <= '1';
    wait for 10ns;
    clk_in <= '1';
    wait for 5ns;
    clk_in <= '0';
    wait for 5ns;
    reset <= '0';

    for i in 0 to 50 loop
        clk_in <= not clk_in;
        wait for 5ns;
    end loop;
    wait;
end process;

end Behavioral;
