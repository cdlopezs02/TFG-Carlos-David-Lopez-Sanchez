library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaRegisterBankFallingEdge is
    Generic(word:integer :=32);
--  Port ( );
end PruebaRegisterBankFallingEdge;

architecture TestFallingEdge of PruebaRegisterBankFallingEdge is


signal sRegisterToRead1,sRegisterToRead2,sRegisterToWrite: std_logic_vector(4 downto 0):="00000";
signal sdataIn,sRegister1,sRegister2: std_logic_vector(word-1 downto 0):=X"00000000";
signal swrite: std_logic:='0';
signal sclk: std_logic:='1';
signal sreset: std_logic:='1';
constant clock_period : time := 100ns;  -- clock period 10Mhz
begin

    registerBank: entity work.RegisterBank(FallingEdge)
    generic map(word => 32)
    port map(
    RegisterToRead1 =>sRegisterToRead1,
    RegisterToRead2 =>sRegisterToRead2,
    RegisterToWrite =>sRegisterToWrite,
    write =>sWrite,
    clk => sClk,
    reset => sreset,
    dataIn =>sdataIn,
    Register1 =>sRegister1,
    Register2 =>sRegister2 );

    --Process que simula el reloj de 20Mhz
    clock :process
    begin
        sclk<='1';
        wait for clock_period/2;
        sclk<='0';
        wait for clock_period/2;
    end process;
    
    sreset<= '0' after 1 ns;
    test: process
    begin  --write 5 in register 1F and read at the same time
    sRegisterToRead1<="11111";
    sRegisterToRead2<="00000";
    sRegisterToWrite<="11111";
    sdataIn<= X"00000005";
    sWrite<='1';
    wait for clock_period; --read register 1F with port 1
                           -- and write A in register 3
    sRegisterToRead1<="11111";
    sRegisterToRead2<="00000";
    sRegisterToWrite<="00011";
    sdataIn<= X"00001010";
    sWrite<='1';
    wait for clock_period;  --Read register 3 with port 2
    sRegisterToRead1<="00000";
    sRegisterToRead2<="00011";
    sRegisterToWrite<="00000";
    sdataIn<= X"00000000";
    sWrite<='0';
    wait for clock_period -10ns;  
    end process;


end TestFallingEdge;
