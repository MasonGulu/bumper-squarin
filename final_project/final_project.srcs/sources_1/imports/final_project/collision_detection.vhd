library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity collision_detection is
port(
	ball_1_x, ball_1_y,ball_2_x, ball_2_y : IN signed(31 downto 0);
	ball_1_r, ball_2_r : IN signed(31 downto 0);
	colliding : out std_logic
);
end collision_detection;

architecture Behavioral of collision_detection is
	signal x_colliding : std_logic;
	signal y_colliding : std_logic;
	signal r_sum : signed(31 downto 0);
begin
	r_sum <= ball_1_r + ball_2_r;
	x_colliding <= '1' when (((ball_2_x > ball_1_x) AND (r_sum > ball_2_x - ball_1_x)) or
		((ball_1_x > ball_2_x) AND (r_sum > ball_1_x - ball_2_x))) else '0';
	y_colliding <= '1' when (((ball_2_y > ball_1_y) AND (r_sum > ball_2_y - ball_1_y)) or
		((ball_1_y > ball_2_y) AND (r_sum > ball_1_y - ball_2_y))) else '0';
	colliding <= x_colliding and y_colliding;
end Behavioral;
