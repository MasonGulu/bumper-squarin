library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fixed_16_16_multiplier is
Port (
    A: in signed(31 downto 0);
    B: in signed(31 downto 0);
    F: out signed(31 downto 0)
);
end fixed_16_16_multiplier;

architecture Behavioral of fixed_16_16_multiplier is
    signal reg_sum : signed(63 downto 0); -- Fixed point 32.32
begin
    reg_sum <= A * B;
    F <= reg_sum(47 downto 16);

end Behavioral;
