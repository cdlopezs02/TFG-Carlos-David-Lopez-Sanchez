library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaFrecuencyDivider is
--  Port ( );
end PruebaFrecuencyDivider;

architecture Test of PruebaFrecuencyDivider is
constant clock_period : time := 50 ns;  -- clock period 20Mhz
signal sclk:std_logic;
signal clk2,clk4,clk8 : std_logic;
signal sreset: std_logic:= '1';

begin


    clock :process
    begin
        sclk<='0';
        wait for clock_period/2;
        sclk<='1';
        wait for clock_period/2;
    end process;

    
    sreset <= '0' after 10 ns;
    FDivider: entity work.FrecuencyDivider
    port map(
    clk =>sclk,
    reset => sreset,
    clk_2 =>clk2,
    clk_4 => clk4,
    clk_8 => clk8
    );
   

end Test;
