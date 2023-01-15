----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2023 01:19:55 PM
-- Design Name: 
-- Module Name: Counter4Bit - Behavioral
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

entity Counter4Bit is
  Port (
  CLK100MHZ : in std_logic;
  led3, led2, led1, led0 : out std_logic
  );
end Counter4Bit;

architecture Behavioral of Counter4Bit is

signal counter : unsigned(31 downto 0) := x"00000000";

begin

    led3 <= counter(24);
    led2 <= counter(25);
    led1 <= counter(26);
    led0 <= counter(27);
    

    count : process(CLK100MHZ)
    begin
        if(rising_edge(CLK100MHZ)) then
            counter <= counter + 1;
        end if;
    end process;


end Behavioral;
