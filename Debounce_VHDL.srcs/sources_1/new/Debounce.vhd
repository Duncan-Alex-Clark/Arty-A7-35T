----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2023 03:39:49 PM
-- Design Name: 
-- Module Name: Debounce - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debounce is
  Port (
  input, CLK100MHZ : in std_logic;
  output, clk_status : out std_logic
   );

end Debounce;

architecture Behavioral of Debounce is

signal buff1, buff2, buff3, buff_output, out_signal : std_logic := '0';
signal counter : unsigned(31 downto 0) := x"00000000";  
    
begin

    clk_status <= counter(27);
    output <= out_signal;
    
    process(CLK100MHZ)
    begin
        if(rising_edge(CLK100MHZ)) then
            counter <= counter + 1;
        end if;
    end process;
        
    buff_update : process(counter(18))
        begin
            if(rising_edge(counter(18))) then
                buff1 <= input;
                buff2 <= buff1;
                buff3 <= buff2;
                buff_output <= buff1 and buff2 and buff3;
            end if;
        end process;

    output_update : process(buff_output)
        begin
            if(rising_edge(buff_output)) then
                out_signal <= not out_signal;
            end if;
        end process;


end Behavioral;



































