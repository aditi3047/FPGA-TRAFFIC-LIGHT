----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/03/2026 05:02:03 PM
-- Design Name: 
-- Module Name: TRAFFIC_LIGHT - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity TRAFFIC_LIGHT is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        led : out STD_LOGIC_VECTOR(3 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TRAFFIC_LIGHT;

architecture Behavioral of TRAFFIC_LIGHT is

    signal count_1s : unsigned(26 downto 0) := (others => '0');
    signal number   : integer range 0 to 5 := 5;

begin

    -- Use only the rightmost 7-segment digit
    an <= "1110";

    -- 1 second timer for Basys 3 100 MHz clock
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count_1s <= (others => '0');
                number <= 5;
            else
                if count_1s = 99999999 then
                    count_1s <= (others => '0');

                    if number = 0 then
                        number <= 5;
                    else
                        number <= number - 1;
                    end if;

                else
                    count_1s <= count_1s + 1;
                end if;
            end if;
        end if;
    end process;

    -- LED control
    process(number)
    begin
        if number = 5 or number = 4 then
            led <= "1111";
        elsif number = 3 or number = 2 or number = 1 then
            led <= "0011";
        else
            led <= "0000";
        end if;
    end process;

    -- 7-segment display decoder
    -- Basys 3 segments are active LOW
    process(number)
    begin
        case number is
            when 5 =>
                seg <= "0010010";
            when 4 =>
                seg <= "0011001";
            when 3 =>
                seg <= "0110000";
            when 2 =>
                seg <= "0100100";
            when 1 =>
                seg <= "1111001";
            when 0 =>
                seg <= "1000000";
            when others =>
                seg <= "1111111";
        end case;
    end process;

end Behavioral;