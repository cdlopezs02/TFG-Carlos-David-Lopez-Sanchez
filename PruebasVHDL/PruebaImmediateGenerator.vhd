library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaImmediateGenerator is
--  Port ( );
end PruebaImmediateGenerator;

architecture Test of PruebaImmediateGenerator is

signal instruction1,immediate1: std_logic_vector(31 downto 0):= X"00000000";

begin

    ImmediateGenerator1:entity work.ImmediateGenerator(Base)
    port map(
     instruction =>instruction1,
     immediate=> immediate1 );

    test: process
    begin 
    --Type R: No usa immediatos. op: X3= x1 +x2, Inm=0
    instruction1 <="00000000001000001000000110110011"; 
    wait for 10ns; 
    -- Type I: op:X3= x1 + 5 Inm=5
    instruction1 <= "00000000010100001000000100010011"; 
    wait for 10 ns;
    -- Type S: op:Sw x3,x0(2) Inm=2 
    instruction1 <= "00000000001100000010000100100011"; 
    wait for 10 ns; 
    -- Type B: op: Beq x1,x2, pc +(-4) Inm=-4
    instruction1 <= "11111110001000001000111011100011"; 
    wait for 10 ns; 
    end process;
end Test;
