library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity the_bigger_boy is
port(
    reset : in std_logic; -- active high reset
    sys_clk : in std_logic; -- 100MHz system clock
    physics_clk : in std_logic;
    colors : out std_logic_vector(2 downto 0); -- 1 bit RGB
    h_sync : out std_logic;
    v_sync : out std_logic
);
end the_bigger_boy;

architecture Behavioral of the_bigger_boy is
    component vga_controller IS
    PORT(
        pixel_clk : IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
        reset_n   : IN   STD_LOGIC;  --active low asycnchronous reset
        h_sync    : OUT  STD_LOGIC;  --horiztonal sync pulse
        v_sync    : OUT  STD_LOGIC;  --vertical sync pulse
        disp_ena  : OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
        column    : OUT  INTEGER;    --horizontal pixel coordinate
        row       : OUT  INTEGER;    --vertical pixel coordinate
        n_blank   : OUT  STD_LOGIC;  --direct blacking output to DAC
        n_sync    : OUT  STD_LOGIC   --sync-on-green output to DAC
    );
    END component;
    component ball_physics_controller is
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
    end component;
    component clock_div_100MHz_to_25_175_MHz is
    port( 
        clk,reset: in std_logic;
        clock_out: out std_logic
    );
    end component;
--    signal physics_clk : std_logic;
    signal pixel_clk : std_logic;
    signal reset_n : std_logic;
    
    signal column    : INTEGER;    --horizontal pixel coordinate
    signal row       : INTEGER;    --vertical pixel coordinate
    signal display_en : std_logic;
begin
    physics : ball_physics_controller port map(
        force_x1 => x"00010000",
        force_y1 => x"00000000",
        mass_1 => x"00010000",
        radius_1 => to_signed(60, 16) & x"0000",

        force_x2 => x"00000000",
        force_y2 => x"00000000",
        mass_2 => x"00010000",
        radius_2 => to_signed(60, 16) & x"0000",
        
        reset => reset,
        phys_clk => physics_clk
    );
    reset_n <= not reset;
    vga : vga_controller port map(
        pixel_clk => pixel_clk,
        reset_n => reset_n,
        column => column,
        row => row,
        v_sync => v_sync,
        h_sync => h_sync,
        disp_ena => display_en
    );
    pixel_clk_div : clock_div_100MHz_to_25_175_MHz port map(
        clk => sys_clk,
        reset => reset,
        clock_out => pixel_clk
    );
    

end Behavioral;
