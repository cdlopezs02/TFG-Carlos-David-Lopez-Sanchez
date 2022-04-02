library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.All;


entity GenericDecoder is
    generic(word_bits:integer:=5);
    Port (a: in std_logic_vector(word_bits-1 downto 0);
          output: out std_logic_vector(2**word_bits-1 downto 0) );
end GenericDecoder;

architecture Base of GenericDecoder is
begin
    decoder: process(a)
    begin
        output <= (others => '0');
        output(to_integer(unsigned(a))) <= '1';
    end process;
end Base;
