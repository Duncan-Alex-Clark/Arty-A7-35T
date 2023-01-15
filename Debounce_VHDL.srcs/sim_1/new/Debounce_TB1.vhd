----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2023 04:45:21 PM
-- Design Name: 
-- Module Name: Debounce_TB1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debounce_TB1 is
--  Port ( );
end Debounce_TB1;

architecture Behavioral of Debounce_TB1 is

    signal input, CLK100MHZ : std_logic := '0';

begin

    UUT : entity work.Debounce port map(input => input, CLK100MHZ => CLK100MHZ);
    
    CLK100MHZ <= not CLK100MHZ after 5ns;
    
--    update_input : process
--    begin
--        input <= '1' after 1ms, '0' after 1.5ms, '1' after 2ms, '0' after 5ms, '1' after 11ms, '0' after 20ms;
--        wait for 40ms;
--    end process;
    
    
end Behavioral;