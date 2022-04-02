library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaBiestableDRisingEdge is
--  Port ( );
end PruebaBiestableDRisingEdge;

architecture TestRisingEdge of PruebaBiestableDRisingEdge is
signal sd,sreset,senable,sq: std_logic:='0';

signal sclk: std_logic:='1';
constant clock_period : time := 50ns;  -- clock period 

begin
    
    --Process que simula el reloj 
    clock :process
    begin
        sclk<='0';
        wait for clock_period/2;
        sclk<='1';
        wait for clock_period/2;
    end process;
    
    
    Biestable: entity work.BiestableD(RisingEdge)
    port map(
    d => sd,
    clk => sclk,
    reset => sreset,
    enable => senable,
    q => sq );
    
    test: process
    begin                   --Guardar Nivel Bajo
    sd <= '0';
    sreset <= '0';
    senable<= '1';
    wait for clock_period;  --Guardar nivel alto
    sd <= '1';
    sreset <= '0';
    senable<= '1';
    wait for clock_period;  --Leer valor guardado
    sd <= '0';
    sreset <= '0';
    senable<= '0';
    wait for clock_period;  --reset 
    sd <= '1';
    sreset <= '1';
    senable<= '0';
    wait for clock_period;  

    end process;

end TestRisingEdge;