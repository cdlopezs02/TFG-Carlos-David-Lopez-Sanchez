library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterXbits is
  Generic(word:integer :=32);
  Port (d: in std_logic_vector(word-1 downto 0);
        clk: in std_logic;
        reset : in std_logic;
        enable: in std_logic;
        q: out std_logic_vector(word-1 downto 0) );
end RegisterXbits;

architecture RisingEdge of RegisterXbits is 

begin
    RegXbits: for i in 0 to word-1 generate
        Biestable: entity work.BiestableD(RisingEdge) port map(
        d =>d(i),
        clk =>clk,
        reset =>reset,
        enable =>enable,
        q =>q(i) );
    end generate;
        
end RisingEdge;

architecture FallingEdge of RegisterXbits is

begin
    RegXbits: for i in 0 to word-1 generate
        Biestable: entity work.BiestableD(FallingEdge) port map(
        d =>d(i),
        clk =>clk,
        reset =>reset,
        enable =>enable,
        q =>q(i) );
    end generate;
        
end FallingEdge;
