library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PruebaGenericDecoder is
generic(word_bits:integer:=5);

--  Port ( );
end PruebaGenericDecoder;

architecture Test of PruebaGenericDecoder is
signal sa: std_logic_vector(3-1 downto 0):= (others => '0');
signal soutput: std_logic_vector(2**3-1 downto 0);
begin

    decoder: entity work.GenericDecoder(Base)
    generic map(word_bits => 3)
    port map(
    a => sa,
    output => soutput
    ); 

    test: process
    begin 
    sa <= "000"; 
    wait for 20 ns; 
    sa <= "001";
    wait for 20 ns; 
    sa <= "100";
    wait for 20 ns;  
    sa <= "011";
    wait for 20 ns;  
    sa <= "101";
    wait for 20 ns; 
    sa <= "111";
    wait for 20 ns;  
    end process;

end Test;
