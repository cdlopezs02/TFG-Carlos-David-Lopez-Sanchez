library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.All;
entity Memory is
  generic(address_bits: integer:= 10;
          word_bits: integer:= 32);
  Port (addr: in std_logic_vector(address_bits-1 downto 0);
        read: in std_logic;
        write: in std_logic;
        enable: in std_logic; -- activo a nivel bajo
        clk: in std_logic;
        dataIn: in std_logic_vector(word_bits-1 downto 0) ;
        
        dataOut: out std_logic_vector(word_bits-1 downto 0) 
  );
end Memory;

architecture Instructions of Memory is
    Type mem is array(0 to 2**address_bits-1) of std_logic_vector(word_bits-1 downto 0);
    signal memory : mem:=( 
                              --Prueba caótica con todas las instrucciones  
--                            "00000000000000000010000010000011", --lw 0(x0=0),x1
--                            "00000000000100001000000100010011", --Addi x1+1, x2
--                            "00000000001000001000000110110011", --Add x1+x2, x3    
--                            "01000000001000011000001000110011", --Sub x3-x2, x4 
--                            "01000000001100010000001010110011", --Sub x2-x3, x5  
--                            "00000000001100001110001100110011", --Or  x1,x2, x6   
--                            "00000000011000001111001110110011", --And x6,x1, x7
--                            "00000000001100000010000010100011", --Sw 1(x0=0), x3 
--                            "00000000000100000010010000000011", --lw 1(x0=0) , x8 
--                            "11111110010000001000111011100011", --Beq x1==x4, -2 al PC 
                              --Prueba 1 Monociclo
                              "00000000011000000000000010010011", --Addi x1,6(x0)       0
                              "00000000001000000000000100010011", --Addi x2,2(x0)       1
                              "00000000000100000000000110010011", --Addi x3,1(x0)       2
                              "00000000001000011000001000110011", --Add x4, x2, x3      3
                              "00000000000000000000000000000000", --Nop                 4 
                              "00000000010000001000001001100011", --Beq x4, x1, +4      5
                              "01000000010000001000000010110011", --Sub x1, x1, x4      6
                              "00000000000000000000000000000000", --Nop                 7            
                              "11111110000000000000111001100011", --Beq x0, x0, -4      8
                              "00000000000000000000000000000000", --Nop                 9
                              --Prueba 2 Monociclo
--                              "00000000001100000000000010010011", --Addi x1,3(x0)
--                              "00000000000000000010000100000011", --Lw x2,0(x0)
--                              "00000000001000001111000110110011", --And x3,x1,x2
--                              "00000000001000001110001000110011", --Or x4,x1,x2
--                              "00000000010000011010000000100011", --Sw x4, 0(x3)
--                              "00000000000000011010001010000011", --Lw x5, 0(x3)
                               --Prueba de las pruebas:
--                               "00000000011000000000000010010011", --Addi x1,6(x0)  
--                               "00000000001100000000001000010011",  --Addi x4, 3(x0)  
--                               "00000000000000000000000000000000",   --nop
--                               "01000000010000001000000010110011", --Sub x1, x1, x4  
--                               "00000000000000001000001110110011",  --Addi x7, x1 , x0

                               others => (31 downto 0=> '0'));
begin

    process(clk,addr,read,write,enable)
    begin
    if enable='0' then
        if(clk'event and clk ='0') then --flanco de bajada
            if(read='1' and write='0') then
                dataOut <= memory(to_integer(unsigned(addr)));
            elsif (read='0' and write='1') then
                memory(to_integer(unsigned(addr))) <= dataIn;
            end if;
        end if;
    end if;
    end process;

end Instructions;



architecture Data of Memory is
    Type mem is array(0 to 2**address_bits-1) of std_logic_vector(word_bits-1 downto 0);
    signal memory : mem:=(  
                                --Prueba 1                             
                                "00000000000000000000000000000010",                  
                            others => (31 downto 0=> '0'));
begin

    process(clk,addr,read,write,enable)
    begin
    if enable='0' then
        if(clk'event and clk ='1') then --flanco de subida
            if(read='1' and write='0') then
                dataOut <= memory(to_integer(unsigned(addr)));
            elsif (read='0' and write='1') then
                memory(to_integer(unsigned(addr))) <= dataIn;
            end if;
        end if;
    end if;
    end process;

end Data;
