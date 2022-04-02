library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaMemoriaXbits is
  generic(address_bits: integer:= 10;
          word_bits: integer:= 32);
end PruebaMemoriaXbits;

architecture Test of PruebaMemoriaXbits is

constant clock_period : time := 50ns;  -- clock period 20Mhz
signal saddr: std_logic_vector(address_bits-1 downto 0):= "0000000000";
signal sread,swrite,senable : std_logic:= '0';
signal sclk: std_logic:= '1';
signal sdataIn,sdataOut : std_logic_vector(word_bits-1 downto 0):=X"00000000";



begin

    memoria1kx32: entity work.Memory(Data)
    generic map(
    address_bits => address_bits,
    word_bits => word_bits)
    port map(
    addr =>saddr,
    read=>sread,
    write => swrite,
    enable=> senable,
    clk=>sclk,
    dataIn => sdataIn ,
    dataOut => sdataOut);
    
    --Process que simula el reloj de 20Mhz
    clock :process
    begin
        sclk<='0';
        wait for clock_period/2;
        sclk<='1';
        wait for clock_period/2;
    end process;
    
    test: process
    begin                  
    saddr <= "0000000000"; --Leer direccion 0
    sread <= '1';
    swrite<= '0';
    senable <='0'; 
    sdataIn <= X"00000000"; 
    wait for clock_period;-- Escribir 4 en dir 0
    saddr <= "0000000000";
    sread <= '0';
    swrite<= '1';
    senable <='0'; 
    sdataIn <= X"00000004";
    wait for clock_period;  -- Escribir 23 en dir 3fc
    saddr <= "1111111100";
    sread <= '0';
    swrite<= '1';
    senable <='0'; 
    sdataIn <= X"00000023";
    wait for clock_period; -- Leer direccion 3fc
    saddr <= "1111111100";
    sread <= '1';
    swrite<= '0';
    senable <='0'; 
    sdataIn <= X"00000000";
    wait for clock_period;  -- Leer direccion 0
    saddr <= "0000000000";
    sread <= '1';
    swrite<= '0';
    senable <='0'; 
    sdataIn <= X"00000000";
    wait for clock_period; -- Escribir en 0 con enable desactivado
    saddr <= "0000000000";
    sread <= '0';
    swrite<= '1';
    senable <='1'; 
    sdataIn <= X"00000045";
    wait for clock_period;  -- Leer 3fccon enable desactivado
    saddr <= "1111111100";
    sread <= '1';
    swrite<= '0';
    senable <='1'; 
    sdataIn <= X"00000045";
    wait for clock_period;
    end process;

end Test;
