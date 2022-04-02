library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RiscVControlUnit is
    Generic(word:integer :=32);
    Port (
    InstructionCode: in std_logic_vector(word-1 downto 0);
    
    branch: out std_logic;
    registerWrite: out std_logic;
    AluInputBMux: out std_logic;
    AluOperation: out std_logic_vector(1 downto 0);
    MemRead: out std_logic;
    MemWrite: out std_logic;
    DatatoRegisterMux: out std_logic ;
    RdEqualsRsx: out std_logic   
    );
end RiscVControlUnit;

architecture Base of RiscVControlUnit is
signal opcode: std_logic_vector(6 downto 0);
signal func3 : std_logic_vector(2 downto 0);
signal func7:  std_logic_vector(6 downto 0);
signal Rd,Rs1,Rs2: std_logic_vector (4 downto 0);

begin

opcode <= InstructionCode(06 downto 00);
Rd     <= InstructionCode(11 downto 07);
func3  <= InstructionCode(14 downto 12);
Rs1    <= InstructionCode(19 downto 15);
Rs2    <= InstructionCode(24 downto 20);
func7  <= InstructionCode(31 downto 25);

    ControlUnitFSM: process (InstructionCode,opcode,func3,func7,Rd,Rs1,Rs2)
    begin
     
    case opcode is 
    when "0110011" => 
        case func3 is
        when "000" =>  
            case func7 is
                when "0000000" =>           -- Add
                    branch <= '0';
                    registerWrite <='1'; 
                    AluInputBMux <= '0';
                    AluOperation <= "10";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    if (Rd and (not Rs1))= "00000" then
                        RdEqualsRsx <= '1';
                    else
                        RdEqualsRsx <= '0';
                    end if;
                when "0100000" =>           -- sub
                    branch <= '0';
                    registerWrite <='1'; 
                    AluInputBMux <= '0';
                    AluOperation <= "11";
                    MemRead <= '0';
                    MemWrite <= '0';
                    if (Rd and (not Rs1))= "00000" then
                        RdEqualsRsx <= '1';
                    else
                        RdEqualsRsx <= '0';
                    end if;
                    DatatoRegisterMux <= '0';
                when others =>      --nop
                    branch <= '0';
                    registerWrite <='0'; 
                    AluInputBMux <= '0';
                    AluOperation <= "00";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    RdEqualsRsx <='0';
            end case;
        when "110" =>   
            case func7 is
                when "0000000" =>  -- Or
                    branch <= '0';
                    registerWrite <='1'; 
                    AluInputBMux <= '0';
                    AluOperation <= "01";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    if (Rd and (not Rs1))= "00000" then
                        RdEqualsRsx <= '1';
                    else
                        RdEqualsRsx <= '0';
                    end if;
                when "0100000" =>  
                branch <= '0';
                when others =>   --nop
                    branch <= '0';
                    registerWrite <='0'; 
                    AluInputBMux <= '0';
                    AluOperation <= "00";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    RdEqualsRsx <='0';
            end case;
        when "111" =>
            case func7 is
                when "0000000" =>  -- And
                    branch <= '0';
                    registerWrite <='1'; 
                    AluInputBMux <= '0';
                    AluOperation <= "00";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    if (Rd and (not Rs1))= "00000" then
                        RdEqualsRsx <= '1';
                    else
                        RdEqualsRsx <= '0';
                    end if;
                when others =>   --nop
                    branch <= '0';
                    registerWrite <='0'; 
                    AluInputBMux <= '0';
                    AluOperation <= "00";
                    MemRead <= '0';
                    MemWrite <= '0';
                    DatatoRegisterMux <= '0';
                    RdEqualsRsx <='0';
            end case; 
        when others =>   --nop
            branch <= '0';
            registerWrite <='0'; 
            AluInputBMux <= '0';
            AluOperation <= "00";
            MemRead <= '0';
            MemWrite <= '0';
            DatatoRegisterMux <= '0'; 
            RdEqualsRsx <='0';
        end case;
    when "0010011" => --Addi
        branch <= '0';
        registerWrite <='1'; 
        AluInputBMux <= '1';
        AluOperation <= "10";
        MemRead <= '0';
        MemWrite <= '0';
        DatatoRegisterMux <= '0';
        if (Rd and (not Rs1))= "00000" then
            RdEqualsRsx <= '1';
        else
            RdEqualsRsx <= '0';
        end if;
    when "1100011" => 
        case func3 is
            when "000" => -- Beq
                branch <= '1';
                registerWrite <='0'; 
                AluInputBMux <= '0';
                AluOperation <= "11";
                MemRead <= '0';
                MemWrite <= '0';
                DatatoRegisterMux <= '0'; 
                RdEqualsRsx <='0';
            when others =>   --nop
                branch <= '0';
                registerWrite <='0'; 
                AluInputBMux <= '0';
                AluOperation <= "00";
                MemRead <= '0';
                MemWrite <= '0';
                DatatoRegisterMux <= '0';  
                RdEqualsRsx <='0';
        end case;        
    when "0000011" => 
        case func3 is
            when "010" => -- Lw
                branch <= '0';
                registerWrite <='1'; 
                AluInputBMux <= '1';
                AluOperation <= "10";
                MemRead <= '1';
                MemWrite <= '0';
                DatatoRegisterMux <= '1';
            when others =>   --nop
                branch <= '0';
                registerWrite <='0'; 
                AluInputBMux <= '0';
                AluOperation <= "00";
                MemRead <= '0';
                MemWrite <= '0';
                DatatoRegisterMux <= '0';  
                RdEqualsRsx <='0';
        end case;
    when "0100011" => 
        case func3 is
            when "010" => -- Sw
                branch <= '0';
                registerWrite <='0'; 
                AluInputBMux <= '1';
                AluOperation <= "10";
                MemRead <= '0';
                MemWrite <= '1';
                DatatoRegisterMux <= '0';  
                RdEqualsRsx <='0';
            when others =>   --nop
                branch <= '0';
                registerWrite <='0'; 
                AluInputBMux <= '0';
                AluOperation <= "00";
                MemRead <= '0';
                MemWrite <= '0';
                DatatoRegisterMux <= '0';  
                RdEqualsRsx <='0';
        end case;
    when others =>   --nop
        branch <= '0';
        registerWrite <='0'; 
        AluInputBMux <= '0';
        AluOperation <= "00";
        MemRead <= '0';
        MemWrite <= '0';
        DatatoRegisterMux <= '0';
        RdEqualsRsx <='0';
    end case;   
    end process;

end Base;
