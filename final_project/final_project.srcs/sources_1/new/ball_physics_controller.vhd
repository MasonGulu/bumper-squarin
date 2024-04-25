library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ball_physics_controller is
Port (
    force_x1 : in signed(31 downto 0);
    force_y1 : in signed(31 downto 0);
    mass_1 : in signed(31 downto 0);
    radius_1 : in signed(31 downto 0);
    
    force_x2 : in signed(31 downto 0);
    force_y2 : in signed(31 downto 0);
    mass_2 : in signed(31 downto 0);
    radius_2 : in signed(31 downto 0);
    
    reset : in std_logic;
    phys_clk : in std_logic;
    
    pos_x1 : out signed(31 downto 0);
    pos_y1 : out signed(31 downto 0);
    pos_x2 : out signed(31 downto 0);
    pos_y2 : out signed(31 downto 0)
);
end ball_physics_controller;

architecture Behavioral of ball_physics_controller is
    signal pos_x1_reg : signed(31 downto 0);
    signal pos_y1_reg : signed(31 downto 0);
    signal vel_x1_reg : signed(31 downto 0);
    signal vel_y1_reg : signed(31 downto 0);
    signal acc_x1_reg : signed(31 downto 0);
    signal acc_y1_reg : signed(31 downto 0);

    signal pos_x2_reg : signed(31 downto 0);
    signal pos_y2_reg : signed(31 downto 0);
    signal vel_x2_reg : signed(31 downto 0);
    signal vel_y2_reg : signed(31 downto 0);
    signal acc_x2_reg : signed(31 downto 0);
    signal acc_y2_reg : signed(31 downto 0);
    
    signal colliding : std_logic;
    signal collided_vel_x1 : signed(31 downto 0);
    signal collided_vel_y1 : signed(31 downto 0);
    signal collided_vel_x2 : signed(31 downto 0);
    signal collided_vel_y2 : signed(31 downto 0);
    
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
    component collision_velocity_calculator is
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
    end component;
    component collision_detection is
    port(
        ball_1_x, ball_1_y,ball_2_x, ball_2_y : IN signed(31 downto 0);
        ball_1_r, ball_2_r : IN signed(31 downto 0);
        colliding : out std_logic
    );
    end component;
begin
    acc_div_x1 : fixed_16_16_divider port map(
        F => acc_x1_reg,
        A => force_x1,
        B => mass_1
    );
    acc_div_y1 : fixed_16_16_divider port map(
        F => acc_y1_reg,
        A => force_y1,
        B => mass_1
    );
    acc_div_x2 : fixed_16_16_divider port map(
        F => acc_x2_reg,
        A => force_x2,
        B => mass_2
    );
    acc_div_y2 : fixed_16_16_divider port map(
        F => acc_y2_reg,
        A => force_y2,
        B => mass_2
    );
    collision_calculator : collision_velocity_calculator port map(
        mass_1 => mass_1,
        mass_2 => mass_2,
        vel_1x => vel_x1_reg,
        vel_1y => vel_y1_reg,
        vel_2x => vel_x2_reg,
        vel_2y => vel_y2_reg,
        new_vel_1x => collided_vel_x1,
        new_vel_1y => collided_vel_y1,
        new_vel_2x => collided_vel_x2,
        new_vel_2y => collided_vel_y2
    );
    collision_detector : collision_detection port map(
        ball_1_x => pos_x1_reg,
        ball_1_y => pos_y1_reg,
        ball_1_r => radius_1,
        ball_2_x => pos_x2_reg,
        ball_2_y => pos_y2_reg,
        ball_2_r => radius_2,
        colliding => colliding
    );
    process(phys_clk) is
    begin
        if (rising_edge(phys_clk)) then
            if (reset = '1') then
                pos_x1_reg <= to_signed(180,16) & x"0000";
                pos_y1_reg <= to_signed(240,16) & x"0000";
                vel_x1_reg <= x"00000000";
                vel_y1_reg <= x"00000000";

                pos_x2_reg <= to_signed(460,16) & x"0000";
                pos_y2_reg <= to_signed(240,16) & x"0000";
                vel_x2_reg <= x"00000000";
                vel_y2_reg <= x"00000000";
            elsif (colliding = '1') then
                vel_x1_reg <= collided_vel_x1;
                vel_y1_reg <= collided_vel_y1;
                vel_x2_reg <= collided_vel_x2;
                vel_y2_reg <= collided_vel_y2;
            else
                pos_x1_reg <= pos_x1_reg + vel_x1_reg;
                pos_y1_reg <= pos_y1_reg + vel_y1_reg;
                vel_x1_reg <= vel_x1_reg + acc_x1_reg;
                vel_y1_reg <= vel_y1_reg + acc_y1_reg;
                
                pos_x2_reg <= pos_x2_reg + vel_x2_reg;
                pos_y2_reg <= pos_y2_reg + vel_y2_reg;
                vel_x2_reg <= vel_x2_reg + acc_x2_reg;
                vel_y2_reg <= vel_y2_reg + acc_y2_reg;
            end if;
        end if;
    end process;
    
    pos_x1 <= pos_x1_reg;
    pos_y1 <= pos_y1_reg;
    pos_x2 <= pos_x2_reg;
    pos_y2 <= pos_y2_reg;

end Behavioral;
