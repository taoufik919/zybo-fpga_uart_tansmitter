----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2026 10:31:54 AM
-- Design Name: 
-- Module Name: baud_rate_generator - Behavioral
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

entity baud_rate_generator is
generic (clk_freq : integer;
         baud_rate : integer);

Port ( clk : in STD_LOGIC;
      baud_tick : out STD_LOGIC);
end baud_rate_generator;

architecture Behavioral of baud_rate_generator is
constant baud : integer:= clk_freq/baud_rate;
signal count : integer:= 0;
signal tick : std_logic :='0';
begin
process (clk)
begin
    if rising_edge (clk) then
        tick <='0';
        if count = baud-1 then
            tick <='1';
            count <= 0;
         else
            count <= count+1 ; 
         end if;
      end if;
end process;
baud_tick <=tick;
end Behavioral;
