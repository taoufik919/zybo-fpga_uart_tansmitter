----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2026 10:31:54 AM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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

entity transmitter is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           send : in STD_LOGIC;
           data_to_send : in std_logic_vector(7 downto 0);
           baud_tick: in std_logic;
           busy : out STD_LOGIC;
           load_data: out std_logic ;
           uart_tx : out STD_LOGIC);
end transmitter;

architecture Behavioral of transmitter is
type trasmitter_states is (idle, start_bit, data,stop_bit);
signal  p_state : trasmitter_states:= idle;
signal  next_state : trasmitter_states;
signal data_index : integer range 0 to 7:=0;
signal data_reg : std_logic_vector (7 downto 0) := (others=> '0'); 
signal btn_prev     : std_logic := '0';
signal send_pending : std_logic := '0';


begin

output : process (all)
begin
    busy <= '1'; uart_tx <= '1'; load_data <= '0';
    case p_state is
        when idle =>
            busy <= '0';
            if send = '1' and baud_tick = '1' then
                load_data <= '1';          -- tells loader the byte is latched
            end if;
        when start_bit => uart_tx <= '0';
        when data      => uart_tx <= data_reg(data_index);
        when stop_bit  => null;
    end case;
end process;

seq : process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            p_state    <= idle;
            data_index <= 0;
        else
            p_state <= next_state;
            if p_state = idle and send = '1' and baud_tick = '1' then
                data_reg <= data_to_send;
            end if;
            if p_state = data and baud_tick = '1' then
                if data_index = 7 then data_index <= 0;
                else data_index <= data_index + 1;
                end if;
            end if;
        end if;

    end if;
end process;

comb : process (all)
begin
    next_state <= p_state;
    case p_state is
        when idle      => if send = '1' and baud_tick = '1' then next_state <= start_bit; end if;
        when start_bit => if baud_tick = '1' then next_state <= data; end if;
        when data      => if baud_tick = '1' and data_index = 7 then next_state <= stop_bit; end if;
        when stop_bit  => if baud_tick = '1' then next_state <= idle; end if;
    end case;
end process;

end Behavioral;
