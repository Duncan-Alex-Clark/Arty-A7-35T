----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2023 12:32:01 PM
-- Design Name: 
-- Module Name: Debouncer - Behavioral
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
use IEEE.numeric_std.all;

entity Debouncer is
  Port ( 
  input, CLK100MHZ : in std_logic;
  output : out std_logic
  );
end Debouncer;

architecture Behavioral of Debouncer is

signal buff1, buff2, buff3, output_signal, toggle : std_logic;
signal counter : unsigned(31 downto 0) := x"00000000";

begin

    output <= toggle;

    clk_counter : process(CLK100MHZ)
    begin
        if(rising_edge(CLK100MHZ)) then
            counter <= counter + 1;
        end if;
    end process;
    
    debounce : process(counter(17))
    begin
        if(rising_edge(counter(17))) then
            buff1 <= input;
            buff2 <= buff1;
            buff3 <= buff2;
            output_signal <= buff1 and buff2 and buff3;
        end if; 
    end process;
    
    output_update : process(output_signal)
    begin
        if(rising_edge(output_signal)) then
            toggle <= not toggle;
        end if;
    end process;

end Behavioral;
