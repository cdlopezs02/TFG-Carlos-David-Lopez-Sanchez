library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaControlUnit is
--  Port ( );
end PruebaControlUnit;

architecture Test of PruebaControlUnit is
signal instruction: std_logic_vector(31 downto 0);
signal AluOperations: std_logic_vector(1 downto 0);
signal branchs,registerWrites,AluInputBMuxs,MemReads,MemWrites, DatatoRegisterMuxs: std_logic ;
begin

    controlUnit: entity work.RiscVControlUnit
    port map(
    InstructionCode =>instruction,
    branch =>branchs,
    registerWrite =>registerWrites, 
    AluInputBMux =>AluInputBMuxs,
    AluOperation =>AluOperations,
    MemRead =>MemReads,
    MemWrite =>MemWrites,
    DatatoRegisterMux =>DatatoRegisterMuxs);
    
    test: process
    constant period: time:= 1 ns;
    begin                        -- Add
    instruction <= "00000000001000001000000110110011";   
    wait for period;             -- Addi
    instruction <= "00000000000100001000000110010011";
    wait for period;             -- Sub
    instruction <= "01000000001000001000000110110011";
    wait for period;             -- Or  
    instruction <= "00000000001000001110000110110011";
    wait for period;             -- And
    instruction <= "00000000001000001111000110110011";
    wait for period;             -- Beq
    instruction <= "00000000001000001000000101100111";
    wait for period;             -- Lw
    instruction <= "00000000000000001010000010000011";    
    wait for period;             -- Sw
    instruction <= "00000000001000001010000100100011";
    wait for period;             -- nop
    instruction <= "00000000001000001010000101111111";
    wait for period;
    end process;



end Test;
