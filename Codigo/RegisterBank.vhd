library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.All;

entity RegisterBank is
    Generic(word:integer :=32);
    Port (
    RegisterToRead1: in std_logic_vector(4 downto 0);
    RegisterToRead2: in std_logic_vector(4 downto 0);
    RegisterToWrite: in std_logic_vector(4 downto 0);
    write: in std_logic;
    clk: in std_logic;
    reset: in std_logic;
    dataIn: in std_logic_vector(word-1 downto 0);
    
    Register1: out std_logic_vector(word-1 downto 0);
    Register2: out std_logic_vector(word-1 downto 0)
    );
end RegisterBank;

architecture RisingEdge of RegisterBank is
    component GenericDecoder is
        generic(word_bits:integer:=5);
        Port (a: in std_logic_vector(word_bits-1 downto 0);
              output: out std_logic_vector(2**word_bits-1 downto 0) );
    end component;
    
    Type intermediateMux is array(0 to 31) of std_logic_vector(word-1 downto 0);
    signal temporalQ:intermediateMux;
    signal writeControl:std_logic_vector(word-1 downto 0);
    signal decoderOUTPUT: std_logic_vector(word-1 downto 0);
    
begin

    --Banco de Registros
   RegisterFile: for i in 0 to word-1 generate
         writeControl(i) <= write and decoderOutput(i); 
         RegisterI: entity work.RegisterXbits(RisingEdge) port map(
         d =>dataIN,
         clk=>clk,
         reset=>reset,
         enable=>writeControl(i),
         q=> temporalQ(i)   );
   end generate;
   
   --Decodificador para seleccionar registro donde escribir:
    decoder:GenericDecoder
    port map(
        a => RegisterToWrite,
        output => decoderOutput );
    --Multiplexor para seleccionar el registro a leer
    Register1 <= temporalQ(to_integer(unsigned(RegisterToRead1)));
    Register2 <= temporalQ(to_integer(unsigned(RegisterToRead2))); 
    
end RisingEdge;

--architecture FallingEdge of RegisterBank is
--    component GenericDecoder is
--        generic(word_bits:integer:=5);
--        Port (a: in std_logic_vector(word_bits-1 downto 0);
--              output: out std_logic_vector(2**word_bits-1 downto 0) );
--    end component;
    
--    Type intermediateMux is array(0 to 31) of std_logic_vector(word-1 downto 0);
--    signal temporalQ:intermediateMux;
--    signal writeControl:std_logic_vector(word-1 downto 0);
--    signal decoderOUTPUT: std_logic_vector(word-1 downto 0);
    
--begin

--    --Banco de Registros
--   RegisterFile: for i in 0 to word-1 generate
--         writeControl(i) <= write and decoderOutput(i); 
--         RegisterI: entity work.RegisterXbits(FallingEdge) port map(
--         d =>dataIN,
--         clk=>clk,
--         reset=>reset,
--         enable=>writeControl(i),
--         q=> temporalQ(i)   );
--   end generate;
   
--   --Decodificador para seleccionar registro donde escribir:
--    decoder:GenericDecoder
--    port map(
--        a => RegisterToWrite,
--        output => decoderOutput );
--    --Multiplexor para seleccionar el registro a leer
--    Register1 <= temporalQ(to_integer(unsigned(RegisterToRead1)));
--    Register2 <= temporalQ(to_integer(unsigned(RegisterToRead2))); 
    
--end FallingEdge;
