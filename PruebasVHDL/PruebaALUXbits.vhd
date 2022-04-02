library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PruebaALUXbits is    
generic(bits: integer := 4);
--  Port ( );
end PruebaALUXbits;

architecture Test of PruebaALUXbits is

component ALUXbits is
    generic(bits: integer := 32);
    Port (  a: in std_logic_vector(bits-1 downto 0);
            b: in std_logic_vector(bits-1 downto 0);
            ALUoperation: in std_logic_vector(1 downto 0);
            
            zero: out std_logic;
            overflow: out std_logic;
            ALUresult: out std_logic_vector(bits-1 downto 0));
end component;
signal sa,sb,sALUresult:std_logic_vector(bits-1 downto 0):=X"00000000";
signal szero: std_logic:= '0';   
signal sALUoperation: std_logic_vector(1 downto 0):= "00";    
signal overflow: std_logic;

begin
    ALU: ALUXbits 
    generic map(bits => 32 )
    port map(
    a => sa,
    b => sb,
    ALUoperation => sALUoperation,
    zero =>szero,
    overflow => overflow,
    ALUresult => sALUresult
    );

    test: process
    constant period: time:= 1 ns;
    begin
    
    wait for period; -- and  
    sa <= X"FFFFFFF1";
    sb <= X"10000003";
    sALUoperation <= "00";
    wait for period; -- or 
    sa <= X"FFFFFFF5";
    sb <= X"00000003";
    sALUoperation <= "01";
    wait for period; -- sum
    sa <= X"0000000A";
    sb <= X"00000002";
    sALUoperation <= "10";
    wait for period; -- sum negative number
    sa <= X"0000000A";
    sb <= X"FFFFFFFE";
    sALUoperation <= "10";
    wait for period; -- substract
    sa <= X"00000005";
    sb <= X"00000002";
    sALUoperation <= "11";
    wait for period; -- substract a negative number
    sa <= X"00000005";
    sb <= X"FFFFFFFE";
    sALUoperation <= "11";
    wait for period; -- --overflow when adding test: negative + negative = positive
    sa <= X"8fffffff";
    sb <= X"8ffafff5";
    sALUoperation <= "10";
    wait for period; -- zero test
    sa <= X"f00a0005";
    sb <= X"f00a0005";
    sALUoperation <= "11";
    wait for period; -- --overflow when adding test: positive + positive = positive
    sa <= X"7fffffff";
    sb <= X"00000001";
    sALUoperation <= "10";
    wait for period; -- --overflow when substracting test
    sa <= X"800a0005";
    sb <= X"0f0a0005";
    sALUoperation <= "11";
    wait for period; -- --overflow when substracting test
    sa <= X"0f000005";
    sb <= X"8fffffff";
    sALUoperation <= "11";
    end process;


end Test;


architecture zippedTest of PruebaALUXbits is

component ALUXbits is
    generic(bits: integer := 32);
    Port (  a: in std_logic_vector(bits-1 downto 0);
            b: in std_logic_vector(bits-1 downto 0);
            ALUoperation: in std_logic_vector(1 downto 0);
            
            zero: out std_logic;
            overflow: out std_logic;
            ALUresult: out std_logic_vector(bits-1 downto 0));
end component;
signal sa,sb,sALUresult:std_logic_vector(bits-1 downto 0):="0000";
signal szero: std_logic:= '0';   
signal sALUoperation: std_logic_vector(1 downto 0):= "00";    
signal overflow: std_logic;

begin
    ALU: ALUXbits 
    generic map(bits => 4 )
    port map(
    a => sa,
    b => sb,
    ALUoperation => sALUoperation,
    zero =>szero,
    overflow => overflow,
    ALUresult => sALUresult
    );

    test: process
    constant period: time:= 50 ns;
    begin
    
    wait for period; -- and  
    sa <= "1101";
    sb <= "0011";
    sALUoperation <= "00";
    wait for period; -- or 
    sa <= "0101";
    sb <= "0011";
    sALUoperation <= "01";
    wait for period; -- sum 3+2=5
    sa <= "0011";
    sb <= "0010";
    sALUoperation <= "10";
    wait for period; -- sum negative number
    sa <= "0110";    -- 6 +(-3)=3
    sb <= "1101";
    sALUoperation <= "10";
    wait for period; -- substract 5-3=2
    sa <= "0101"; 
    sb <= "0011";
    sALUoperation <= "11";
    wait for period; -- substract a negative number
    sa <= "0101";    -- 5 -(-2)= 7
    sb <= "1110";
    sALUoperation <= "11";
    wait for period; --overflow when adding: 
    sa <= "1010";    --negative + negative = positive
    sb <= "1100";    -- (-6)+(-4)= -10  OVERFLOW!!
    sALUoperation <= "10";
    wait for period; --overflow when adding: 
    sa <= "0101";    --positive + positive = negative 
    sb <= "0100";    -- 5+4=9
    sALUoperation <= "10";
    wait for period; --overflow when substracting test
    sa <= "1001";    -- -7-3=-10
    sb <= "0011";
    sALUoperation <= "11";
    wait for period; --overflow when substracting test
    sa <= "0001";    -- 1 -(-7)=8
    sb <= "1001";
    sALUoperation <= "11";    
    wait for period; -- zero test 2-2=0
    sa <= "0010";
    sb <= "0010";
    sALUoperation <= "11";    
    end process;


end zippedTest;
