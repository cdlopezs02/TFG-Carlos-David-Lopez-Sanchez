library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaRegisterXbitsRisingEdge is
Generic(word:integer :=32);

--  Port ( );
end PruebaRegisterXbitsRisingEdge;

architecture RisingEdge of PruebaRegisterXbitsRisingEdge is
constant clock_period : time := 50ns;  -- clock period 20Mhz
signal sclk: std_logic:='0';
signal sd,sq: std_logic_vector(word-1 downto 0):=X"00000000";
signal sreset,senable:std_logic:='0';
begin

    --Process que simula el reloj de 20Mhz
    clock :process
    begin
        sclk<='0';
        wait for clock_period/2;
        sclk<='1';
        wait for clock_period/2;
    end process;

    registerXbits:entity work.RegisterXbits(RisingEdge)
    port map(
    d =>sd,
    clk=>sclk,
    reset=>sreset,
    enable=>senable,
    q=>sq    );

    test: process
    begin                   --inicializar a 0
    sd <= X"00000023";      
    sreset <= '1';
    senable<= '0';
    wait for clock_period;  --Guardar valor
    sd <= X"00000023";
    sreset <= '0';
    senable<= '1';
    wait for clock_period;  --Guardar valor estando desactivado
    sd <= X"00005000";
    sreset <= '0';
    senable<= '0';
    wait for clock_period;  --probar el reset
    sd <= X"00000000";
    sreset <= '1';
    senable<= '0';
    wait for clock_period;  --cambiar valor
    sd <= X"0F000000";
    sreset <= '0';
    senable<= '1';
    wait for clock_period;  
    end process;

end RisingEdge;