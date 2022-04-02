library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ImmediateGenerator is
    generic(word:integer:= 32);
    Port (  instruction: in std_logic_vector(word-1 downto 0);
            immediate: out std_logic_vector(word-1 downto 0));
end ImmediateGenerator;

architecture Base of ImmediateGenerator is
    signal opcode: std_logic_vector(6 downto 0);
begin
opcode <= instruction(6 downto 0);

immediate <= X"00000000" when opcode="0110011" else --Type R
  ((31 downto 11 =>instruction(31)) & instruction(30 downto 20))  when opcode="0000011" or opcode="0010011" or opcode="1100111" else --Type I
  ((31 downto 11 =>instruction(31)) & instruction(30 downto 25) & instruction(11 downto 7)) when opcode="0100011" else --Type S
  ((31 downto 12 =>instruction(31)) & instruction(7) & instruction(30 downto 25)& instruction(11 downto 8) & '0')when opcode="1100011" else --Type SB
   X"00000000";

end Base;
