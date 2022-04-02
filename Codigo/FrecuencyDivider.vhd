library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FrecuencyDivider is
  Port (clk : in std_logic;
        reset : in std_logic;
        clk_2: out std_logic;
        clk_4: out std_logic;
        clk_8: out std_logic );
end FrecuencyDivider;

architecture Base of FrecuencyDivider is
signal q2,q4,q8 : std_logic:='0';
signal NOTq2, NOTq4, NOTq8 : std_logic:= '0';
begin

NOTq2 <= not q2;
    D1: entity work.BiestableD(RisingEdge)
    port map(
        d => NOTq2,
        clk =>clk,
        reset =>reset,
        enable =>'1',
        q =>q2 );

clk_2 <= q2;

NOTq4 <= not q4;
    D2: entity work.BiestableD(RisingEdge)
    port map(
        d => NOTq4,
        clk =>q2,
        reset =>reset,
        enable =>'1',
        q =>q4 );

clk_4 <= q4;

NOTq8 <= not q8;
    D3: entity work.BiestableD(RisingEdge)
    port map(
        d => NOTq8,
        clk =>q4,
        reset =>reset,
        enable =>'1',
        q =>q8 );

clk_8 <= q8;

end Base;
