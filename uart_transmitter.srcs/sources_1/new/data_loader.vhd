----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2026 11:21:47 PM
-- Design Name: 
-- Module Name: data_loader - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_loader is
    Port ( clk        : in  std_logic;
           reset      : in  std_logic;
           btn_send   : in  std_logic;
           load_data  : in  std_logic;   --  from transmitter
           send       : out std_logic;
           data_chunck : out std_logic_vector(7 downto 0));
end data_loader;

architecture Behavioral of data_loader is
    constant ARR_LEN : integer := 9;
    type data_arr is array (0 to ARR_LEN-1) of std_logic_vector(7 downto 0);
    constant data_to_send : data_arr := (
        x"47", x"45", x"54", x"5F", x"54", x"45", x"4D", x"50", x"0A");

    type data_state is (idle, sending);
    signal state     : data_state := idle;
    signal arr_index : integer range 0 to ARR_LEN-1 := 0;
    signal btn_prev  : std_logic := '0';
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state     <= idle;
                arr_index <= 0;
                btn_prev  <= '0';
            else

                btn_prev <= btn_send;
                case state is
                    when idle =>
                        if btn_send = '1' and btn_prev = '0' then
                            arr_index <= 0;
                            state     <= sending;
                        end if;
                    when sending =>
                        if load_data = '1' then
                            if arr_index = ARR_LEN-1 then
                                arr_index <= 0;
                                state     <= idle;   
                            else
                                arr_index <= arr_index + 1;
                            end if;
                        end if;
                end case;
            end if;
        end if;
    end process;

    send       <= '1' when state = sending else '0';
    data_chunck <= data_to_send(arr_index) when state = sending else (others => '0');

end Behavioral;
