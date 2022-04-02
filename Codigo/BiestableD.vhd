library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BiestableD is 
 Port ( d: in std_logic;
        clk: in std_logic;
        reset: in std_logic;  --activo a nivel alto
        enable: in std_logic; --activo a nivel bajo
        q: out std_logic );
end BiestableD;

architecture RisingEdge of BiestableD is
begin

    process (clk, reset)
        begin
            if (reset = '1') then 
                q <='0'; 
            elsif (clk'event and clk = '1' and enable = '1') 
                then q <= d;
            end if;
    end process;

end RisingEdge;

architecture FallingEdge of BiestableD is
begin

    process (clk, reset)
        begin
            if (reset = '1') then 
                q <='0'; 
            elsif (clk'event and clk = '0' and enable = '1') 
                then q <= d;
            end if;
    end process;

end FallingEdge;




