library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity RS32I_Testbench is
--  Port ( );
end RS32I_Testbench;

architecture Behavioral of RS32I_Testbench is
    component RV32I is
        port(CLK, RST : in std_logic; -- clock and reset
             CS, WE : out std_logic; -- chip select and write enable for memory!
             SEL : out std_logic_vector(1 downto 0);
             ADDR, Data_OUT, PC_OUT : out unsigned(31 downto 0); -- address and data out for memory!
             Data_IN, Instruction_IN : in unsigned(31 downto 0)); -- data in from memory!
        end component;
    component Memory is
        port(CLK, CS, WE : in std_logic; -- Clock, chip select, and write enable
             SEL : in std_logic_vector(1 downto 0);
             ADDR, Data_IN, PC_IN : in unsigned(31 downto 0); -- address and data in (address size for this memory only consists of 9 bits)
             Data_OUT, Instruction_OUT : out unsigned(31 downto 0)); -- the output of the memory at ADDR
    end component;
    
    constant W: integer := 16;
    type Iarr is array(0 to W) of unsigned(31 downto 0);
    -- Write a program which counts by 1
    constant Instr_List: Iarr := (
    -- ADDI Test
    x"7FF30313", -- ADD 0x7FF to 0 -> =7FF | Store in register 6
    x"7FF30313", -- ADD 7FF to 7FF -> =FFE | Store in register 6
    x"FF230313", -- ADD -E to FFE -> =FF0 | Store in register 6
    -- SLTI Test
    x"0FF2A393", -- Set t2 = 1 if 0 < 0FF
    x"FFF32393", -- Set t2 = 1 if FF0 < -1, else set t2 to 0
    -- SLTIU Test
    x"FFF33393",
    x"00033393",
    -- XORI Test
    x"FFF34313", -- Set t1 = t1 xor FFFFFFFF | FFFFF00F
    x"ABC34313", -- Set t1 = t1 xor FFFFFABC | 00000AB3
    -- ORI Test
    x"AAA36313", -- Set t1 = 00000AB3 or FFFFFAAA | FFFFFABB
    x"0C636313", -- Set t1 = FFFFFABB or 000000C6 | FFFFFAFF
    -- ANDI Test
    x"7BC37313", -- set t1 = FFFFFAFF and 000007BC | 000002BC
    x"AAA37313", -- set t1 = 000002BC and FFFFFAAA | 000002A8
    -- LW Test
    -- Note that some instruction show misaligned memory output due to byte addressability. The location to read is not a multiple of 0x04.
    x"0033A383", -- set t2 = 0x00+0x03 | 0x03, 04, 05, 06 -> F303137F
    x"00328293", -- ADD 0x003 to 0 and store in register 5
    x"FFF2A383", -- Store data at address 3 - 1 in register 7 | 0x02, 03, 04, 05 -> 03137FF3
    x"0052A383" -- Store instruction 2 into register 7 | FF230313 
    -- LH Test
--    x"00029383", -- Load half word at base address 3 and store in register 7 | 0000A393
--    x"00B29383", -- Load half word at base address 3 + 10 into register 7 | 00008293
--    x"FFF29383", -- Load half word at base address 3 - 1 into register 7 | 00000313
    -- LB Test
--    x"FFE28383", -- Load a byte of memory(3-2) into register 7 | 00000013
--    x"00328383" -- Load a byte of memory(3+3) into register 17 | 00000093
    );
    
    signal CS, WE, CLK: std_logic := '0';
    signal Data_IN, Data_OUT, PC_OUT, Instruction_IN, Address, AddressTB, Address_Mux: unsigned(31 downto 0);
    signal RST, init, WE_Mux, CS_Mux, WE_TB, CS_TB: std_logic;
    signal SEL : std_logic_vector(1 downto 0);
begin
    CPU : RV32I port map(CLK => CLK,
                         RST => RST,
                         CS => CS,
                         WE => WE,
                         SEL => SEL,
                         ADDR => Address,
                         Data_OUT => Data_OUT,
                         Data_IN => Data_IN,
                         PC_OUT => PC_OUT,
                         Instruction_IN => Instruction_IN);
                         
    MEM : Memory port map(CLK => CLK,
                          CS => CS_Mux,
                          WE => WE_Mux,
                          SEL => SEL,
                          ADDR => Address_Mux,
                          Data_IN => Data_OUT,
                          Data_OUT => Data_IN,
                          PC_IN => PC_OUT,
                          Instruction_OUT => Instruction_IN);

    CLK <= not CLK after 10 ns;
    Address_Mux <= AddressTB when init = '1' else Address; 
    WE_Mux <= WE_TB when init = '1' else WE;
    CS_Mux <= CS_TB when init = '1' else CS;
    
    process
    begin
        rst <= '1';
        SEL <= "00";
        wait until rising_edge(CLK);
        
        --Initialize the instructions from the testbench
        init <= '1';
        CS_TB <= '1'; WE_TB <= '1';
        for i in 0 to W loop
            wait until rising_edge(CLK);
            AddressTB <= to_unsigned(4*i,32);
            Data_OUT <= Instr_List(i);
        end loop;
        wait until rising_edge(CLK);
        Data_OUT <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        CS_TB <= '0'; WE_TB <= '0';
        init <= '0';
        wait until rising_edge(CLK);
        rst <= '0';
        SEL <= "ZZ";
        for i in 0 to W loop
            wait until Instruction_IN'event;
        end loop;
        
    end process;
end Behavioral;
