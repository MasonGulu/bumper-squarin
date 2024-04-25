library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity clock_div_100MHz_to_25_175_MHz is
port( 
clk,reset: in std_logic;
clock_out: out std_logic
);
end clock_div_100MHz_to_25_175_MHz;

architecture Behavioral of clock_div_100MHz_to_25_175_MHz is
signal count: std_logic_vector(3 downto 0) := "0001";
signal tmp : std_logic := '0';

begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if(reset='1') then
                count<="0001";
                tmp<='0';
            else
                if (count = 2) then -- 25MHz output approximation
                    tmp <= NOT tmp;
                    count <= "0001";
                else
                    count <= count+1;
                end if;
            end if;
        end if;
    end process;
    clock_out <= tmp;

end Behavioral;
