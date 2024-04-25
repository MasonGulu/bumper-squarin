library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity collision_velocity_calculator is
Port(
    mass_1 : in signed(31 downto 0);
    vel_1x : in signed(31 downto 0);
    vel_1y : in signed(31 downto 0);
    
    mass_2 : in signed(31 downto 0);
    vel_2x : in signed(31 downto 0);
    vel_2y : in signed(31 downto 0);
    
    new_vel_1x : out signed(31 downto 0);
    new_vel_1y : out signed(31 downto 0);

    new_vel_2x : out signed(31 downto 0);
    new_vel_2y : out signed(31 downto 0)
);
end collision_velocity_calculator;

architecture Behavioral of collision_velocity_calculator is
    signal mass_sum : signed(31 downto 0);
    signal m1_min_m2 : signed(31 downto 0);
    signal m2_min_m1 : signed(31 downto 0);
    component fixed_16_16_multiplier is
    Port (
        A: in signed(31 downto 0);
        B: in signed(31 downto 0);
        F: out signed(31 downto 0)
    );
    end component;
                            
    component fixed_16_16_divider is
    Port (                  
        A: in signed(31 downto 0);
        B: in signed(31 downto 0);
        F: out signed(31 downto 0)
    );                      
    end component;
    -- Perfectly Elastic Collision Formula
    -- v1 = (m1 - m2) / (m1 + m2) * u1 + 2m2 / (m1 + m2) * u2
    -- v1 = (m1 - m2) / mass_sum * u1 + 2m2 / mass_sum * u2
    --      ^~~~~~~~           |    |   ^~~          |    |
    --      m1_min_m2          |    |   m2_double    |    |
    --      ^~~~~~~~~~~~~~~~~~~^    |   ^~~~~~~~~~~~~^    |
    --      calc_v1_p1              |   calc_v1_p2        |
    --      ^~~~~~~~~~~~~~~~~~~~~~~~^   ^~~~~~~~~~~~~~~~~~^
    --      calc_v1_p1_x                calc_v1_p2_x
    --                                    
    signal calc_v1_p1 : signed(31 downto 0); -- (m1-m2)/(m1+m2)
    signal calc_v1_p1_x : signed(31 downto 0); -- (m1 - m2)/(m1+m2)*v1x
    signal calc_v1_p1_y : signed(31 downto 0);
    signal m2_double : signed(31 downto 0);
    signal calc_v1_p2 : signed(31 downto 0); -- (2m2)/(m1+m2)
    signal calc_v1_p2_x : signed(31 downto 0); -- (2m2)/(m1+m2)*v2x
    signal calc_v1_p2_y : signed(31 downto 0);
    
    signal calc_v2_p1 : signed(31 downto 0); -- (m1-m2)/(m1+m2)
    signal calc_v2_p1_x : signed(31 downto 0); -- (m1 - m2)/(m1+m2)*v1x
    signal calc_v2_p1_y : signed(31 downto 0);
    signal m1_double : signed(31 downto 0);
    signal calc_v2_p2 : signed(31 downto 0); -- (2m2)/(m1+m2)
    signal calc_v2_p2_x : signed(31 downto 0); -- (2m2)/(m1+m2)*v2x
    signal calc_v2_p2_y : signed(31 downto 0);
begin
    mass_sum <= mass_1 + mass_2;
    m1_min_m2 <= mass_1 - mass_2;
    m2_min_m1 <= mass_2 - mass_1;
    calc_v1_pl_div : fixed_16_16_divider port map(
        F => calc_v1_p1,
        A => m1_min_m2,
        B => mass_sum
    );
    calc_v1_p1_mul_x : fixed_16_16_multiplier port map(
        F => calc_v1_p1_x,
        A => calc_v1_p1,
        B => vel_1x
    );
    m2_double <= mass_2 + mass_2;
    calc_v1_p2_div : fixed_16_16_divider port map(
        F => calc_v1_p2,
        A => m2_double,
        B => mass_sum
    );
    calc_v1_p2_mul_x : fixed_16_16_multiplier port map(
        F => calc_v1_p2_x,
        A => calc_v1_p2,
        B => vel_2x
    );
    new_vel_1x <= calc_v1_p1_x + calc_v1_p2_x;
    calc_v1_p1_mul_y : fixed_16_16_multiplier port map(
        F => calc_v1_p1_y,
        A => calc_v1_p1,
        B => vel_1y
    );
    calc_v1_p2_mul_y : fixed_16_16_multiplier port map(
        F => calc_v1_p2_y,
        A => calc_v1_p2,
        B => vel_2y
    );
    new_vel_1y <= calc_v1_p1_y + calc_v1_p2_y;
    
    -- v2
    calc_v2_p1_div : fixed_16_16_divider port map(
        F => calc_v2_p1,
        A => m2_min_m1,
        B => mass_sum
    );
    m1_double <= mass_1 + mass_1;
    calc_v2_p2_div : fixed_16_16_divider port map(
        F => calc_v2_p2,
        A => m1_double,
        B => mass_sum
    );
    calc_v2_p1_mul_x : fixed_16_16_multiplier port map(
        F => calc_v2_p1_x,
        A => calc_v2_p1,
        B => vel_2x
    );
    calc_v2_p2_mul_x : fixed_16_16_multiplier port map(
        F => calc_v2_p2_x,
        A => calc_v2_p2,
        B => vel_1x
    );
    new_vel_2x <= calc_v2_p1_x + calc_v2_p2_x;
    calc_v2_p1_mul_y : fixed_16_16_multiplier port map(
        F => calc_v2_p1_y,
        A => calc_v2_p1,
        B => vel_2y
    );
    calc_v2_p2_mul_y : fixed_16_16_multiplier port map(
        F => calc_v2_p2_y,
        A => calc_v2_p2,
        B => vel_1y
    );
    new_vel_2y <= calc_v2_p1_y + calc_v2_p2_y;

end Behavioral;
