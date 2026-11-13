----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2026 10:34:15 AM
-- Design Name: 
-- Module Name: uart_transmitter_top - Behavioral
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

entity uart_transmitter_top is
generic (clk_freq : integer := 125_000_000;
         baud_rate : integer := 9600;
         data : std_logic_vector := x"57"
);

    Port ( clk : in STD_LOGIC;
    clk_out : out STD_LOGIC;
           reset : in std_logic;
           btn_in : in std_logic;
           uart_tx : out STD_LOGIC;
           busy : out STD_LOGIC);
end uart_transmitter_top;

architecture Behavioral of uart_transmitter_top is
signal tick : std_logic ;
signal cleaned_btn : std_logic ;

signal data_chunck_tp : std_logic_vector(7 downto 0);
signal send_tp : std_logic ;
signal load_data_tp : std_logic;
begin

--clk_out <=clk;



baud_rate_gener : entity work.baud_rate_generator 
generic map(
clk_freq =>clk_freq, baud_rate=>baud_rate)
port map (clk=>clk,baud_tick=>tick);


transm : entity work.transmitter 
port map (clk=>clk, reset=>reset,send =>send_tp,load_data=>load_data_tp,
data_to_send=>data_chunck_tp,baud_tick=>tick,uart_tx=>uart_tx,busy=>busy);

data_load : entity work.data_loader 
port map (clk=>clk, reset=>reset,btn_send=>cleaned_btn,
send=>send_tp,load_data=>load_data_tp,data_chunck=>data_chunck_tp);

btn_deboun : entity work.button_debounce 
port map (clk=>clk, btn_in=>btn_in,pulse=>cleaned_btn);
end Behavioral;
