library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity RiscV_CPU is
 Generic(word:integer :=32;
         InstructionMemory_address_bits: integer:=10;
         DataMemory_address_bits: integer:= 12 );
end RiscV_CPU;

architecture Base of RiscV_CPU is

    component RegisterXbits is
        Generic
            (word:integer := word);
        Port 
            (d: in std_logic_vector(word-1 downto 0);
            clk: in std_logic;
            reset : in std_logic;
            enable: in std_logic;
            q: out std_logic_vector(word-1 downto 0) );
    end component;
    
    
    component Memory is
    generic
        (address_bits: integer:= InstructionMemory_address_bits;
         word_bits: integer:= 5);
    Port 
        (addr: in std_logic_vector(address_bits-1 downto 0);
        read: in std_logic;
        write: in std_logic;
        enable: in std_logic; -- activo a nivel bajo
        clk: in std_logic;
        dataIn: in std_logic_vector(word_bits-1 downto 0) ;
        dataOut: out std_logic_vector(word_bits-1 downto 0) );
    end component;


    component RegisterBank is
    Generic
        (word:integer := word);
    Port 
        (RegisterToRead1: in std_logic_vector(4 downto 0);
        RegisterToRead2: in std_logic_vector(4 downto 0);
        RegisterToWrite: in std_logic_vector(4 downto 0);
        write: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        dataIn: in std_logic_vector(word-1 downto 0);
        Register1: out std_logic_vector(word-1 downto 0);
        Register2: out std_logic_vector(word-1 downto 0) );
    end component;


    component ALUXbits is
    generic
        (bits: integer := word);
    Port 
        (a: in std_logic_vector(bits-1 downto 0);
        b: in std_logic_vector(bits-1 downto 0);
        ALUoperation: in std_logic_vector(1 downto 0);
        zero: out std_logic;
        ALUresult: out std_logic_vector(bits-1 downto 0) );
    end component;
    
    
    component RiscVControlUnit is
    Generic
        (word:integer := word);
    Port 
        (InstructionCode: in std_logic_vector(word-1 downto 0);
        branch: out std_logic;
        registerWrite: out std_logic;
        AluInputBMux: out std_logic;
        AluOperation: out std_logic_vector(1 downto 0);
        MemRead: out std_logic;
        MemWrite: out std_logic;
        DatatoRegisterMux: out std_logic ;
        RdEqualsRsx: out std_logic );
    end component;
    
    component ImmediateGenerator is
    generic
        (word:integer:= word);
    Port 
        (instruction: in std_logic_vector(word-1 downto 0);
        immediate: out std_logic_vector(word-1 downto 0) );
    end component;

    component FrecuencyDivider is
        Port 
            (clk : in std_logic;
            reset : in std_logic;
            clk_2: out std_logic;
            clk_4: out std_logic;
            clk_8: out std_logic  );
    end component;
    
-- 32 bit signals
    signal InstructionCode: std_logic_vector(word-1 downto 0):=X"00000000";
    signal OutputRegister1,OutputRegister2: std_logic_vector(word-1 downto 0);
    signal AluInputB,AluOutput: std_logic_vector(word-1 downto 0);
    signal ImmediateGeneratorOutput: std_logic_vector(word-1 downto 0);
    signal DataMemOutput: std_logic_vector(word-1 downto 0);
    signal DatatoRegister: std_logic_vector(word-1 downto 0);
    signal bufferOutput: std_logic_vector(word-1 downto 0);

-- 10 bits Signals
    signal PCinput,PCoutput: std_logic_vector(InstructionMemory_address_bits -1 downto 0):= "0000000000";

-- 2 bits signals
    signal AluOperation: std_logic_vector(1 downto 0);
    
-- 1 bit signals
    signal clk,sclk,clk_2,clk_4,clk_8,RB_clk:std_logic;
    signal reset: std_logic:='0';
    signal branch: std_logic:='0';
    signal registerWrite: std_logic;
    signal ZeroAluOutput,AluInputBMux: std_logic;
    signal MemRead,MemWrite: std_logic;
    signal DatatoRegisterMux: std_logic;
    signal updateRegister,RdEqualsRsx: std_logic;

-- constants
    constant clock_period : time := 80 ns;  -- clock period 20Mhz

-- architectural configurations    
    For InstructionMemory : memory use entity work.memory(Instructions);
    For DataMemory : memory use entity work.memory(Data);

begin
-- Clock
    clock :process
    begin
        sclk<='1';
        wait for clock_period/2;
        sclk<='0';
        wait for clock_period/2;
    end process;
    
    clk<= sclk;
-- Special Clock used when Rd equals Rsx in Register Block
    updateRegister<= not clk and not clk_2;

-- Known state Initializer     
    reset<= '1', '0' after clock_period*2; 

-- Clock Divider   
    ClockDivider: frecuencyDivider
    port map(
        clk => clk,
        reset => reset,
        clk_2 => clk_2,
        clk_4 => clk_4,
        clk_8 => clk_8
    );
    
-- Control Unit
    ControlUnit: RiscVControlUnit
    generic map
        (word => word)
    port map(
        InstructionCode => InstructionCode,
        branch => branch,
        registerWrite => registerWrite,
        AluInputBMux => AluInputBMux,
        AluOperation => AluOperation,
        MemRead => MemRead,
        MemWrite => MemWrite,
        DatatoRegisterMux => DatatoRegisterMux,
        RdEqualsRsx => RdEqualsRsx
    );

-- Program Counter Register
    PC: entity work.RegisterXbits(RisingEdge) 
    generic map
        (word => InstructionMemory_address_bits)
    port map(
         d =>PCinput,
         clk=>clk_2,
         reset=>reset,
         enable=>'1',
         q=> PCoutput   
       );
                
-- 1024 words Instruction Memory (4KB)
    InstructionMemory: Memory
    generic map(
        address_bits => InstructionMemory_address_bits,
        word_bits => word)
    port map(
        addr =>PCoutput,
        read=>'1',
        write => '0',
        enable=> '0',
        clk=>clk_2,
        dataIn => X"00000000" , 
        dataOut => InstructionCode
    ); 
       
-- Register Bank
    Registers: RegisterBank 
    generic map
        (word => word)
    port map(
        RegisterToRead1 =>InstructionCode(19 downto 15),
        RegisterToRead2 =>InstructionCode(24 downto 20),
        RegisterToWrite =>InstructionCode(11 downto 7),
        write =>registerWrite,
        clk => RB_clk,
        reset => reset,
        dataIn =>DatatoRegister,
        Register1 =>OutputRegister1,
        Register2 =>OutputRegister2 
    );

-- Inmediate Generator module  
    ImmediateGeneratorR:ImmediateGenerator
    generic map
        (word => word)
    port map(
         instruction =>InstructionCode,
         immediate=> ImmediateGeneratorOutput 
     );
    
-- Arithmetic Logic Unit
    ALU: ALUXbits 
    generic map
        (bits => word )
    port map(
        a => OutputRegister1,
        b => AluInputB,
        ALUoperation => ALUoperation,
        zero =>ZeroAluOutput,
        ALUresult => AluOutput
    );
    
-- 4096 Data Memory (16KB)
    DataMemory: Memory
    generic map(
        address_bits => DataMemory_address_bits,
        word_bits => word) 
    port map(
        addr =>AluOutput(11 downto 0),
        read=> MemRead,
        write => MemWrite,
        enable=> '0',
        clk=>clk,
        dataIn => OutputRegister2, 
        dataOut => DataMemOutput
    ); 
    
-- Next Instruction or branch instruction Multiplexer
    PCinput <= PCoutput + (ImmediateGeneratorOutput(31) &  ImmediateGeneratorOutput(8 downto 0)) when (branch and zeroAluOutput)='1' else
               PCoutput + 1;
    
-- Clock Multiplexor for Register Bank    
    RB_clk<= updateRegister when RdEqualsRsx='1' else clk;
    
-- Alu Input Multiplexor
    AluInputB <= OutputRegister2 when AluInputBMux='0' else
                 ImmediateGeneratorOutput;
    
-- Register Bank data input Multiplexor
    DatatoRegister <= AluOutput     when DatatoRegisterMux='0' else
                      DataMemOutput;
                      
end Base;
