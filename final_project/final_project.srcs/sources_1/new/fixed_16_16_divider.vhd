library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fixed_16_16_divider is
Port (
    A: in signed(31 downto 0);
    B: in signed(31 downto 0);
    F: out signed(31 downto 0)
);
end fixed_16_16_divider;

architecture Behavioral of fixed_16_16_divider is
    signal a_pad : signed(47 downto 0);
    signal b_pad : signed(47 downto 0);
    signal reg_sum : signed(47 downto 0); -- Fixed point 32.16
begin
    a_pad <= A & x"0000"; -- pad to 16.32
    b_pad <= resize(B, b_pad'length); -- pad to 32.16
    
    reg_sum <= a_pad / b_pad;
    
    F <= reg_sum(31 downto 0); -- truncate to 16.16

end Behavioral;
