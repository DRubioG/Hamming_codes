library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity Hamming_decoder is
    port(
        code : in std_logic_vector(12 downto 0);
        data : out std_logic_vector(7 downto 0);
        error : out std_logic
    );
end entity;

architecture arch_Hamming_decoder of Hamming_decoder is

constant C_value : std_logic_vector(15 downto 0) := (0=>'1', others=>'0');

signal e : std_logic_vector(3 downto 0);
signal flip_mask : std_logic_vector(15 downto 0);
signal corr_code : std_logic_vector(11 downto 0);
signal corr_parity : std_logic;

begin

    e(0) <= code(0) xor code(2) xor code(4) xor code(6) xor code(8) xor code(10);
    e(1) <= code(1) xor code(2) xor code(5) xor code(6) xor code(9) xor code(10);
    e(2) <= code(3) xor code(4) xor code(5) xor code(6) xor code(11);
    e(3) <= code(7) xor code(8) xor code(9) xor code(10) xor code(11);

    
    process(e)
    begin
        case e is
            when x"0" => flip_mask <= C_value;
            when x"1" => flip_mask <= C_value(15 downto 1)  & "0";
            when x"2" => flip_mask <= C_value(15 downto 2)  & "00";
            when x"3" => flip_mask <= C_value(15 downto 3)  & "000";
            when x"4" => flip_mask <= C_value(15 downto 4)  & "0000";
            when x"5" => flip_mask <= C_value(15 downto 5)  & "00000";
            when x"6" => flip_mask <= C_value(15 downto 6)  & "000000";
            when x"7" => flip_mask <= C_value(15 downto 7)  & "0000000";
            when x"8" => flip_mask <= C_value(15 downto 8)  & "00000000";
            when x"9" => flip_mask <= C_value(15 downto 9)  & "000000000";
            when x"A" => flip_mask <= C_value(15 downto 10) & "0000000000";
            when x"B" => flip_mask <= C_value(15 downto 11) & "00000000000";
            when x"C" => flip_mask <= C_value(15 downto 12) & "000000000000";
            when x"D" => flip_mask <= C_value(15 downto 13) & "0000000000000";
            when x"E" => flip_mask <= C_value(15 downto 14) & "00000000000000";
            when x"F" => flip_mask <= C_value(15) & "000000000000000";
            when others => flip_mask <= (others=>'0');
        end case;
    end process;
    

    corr_code <= code(11 downto 0) xor flip_mask(12 downto 1);

    corr_parity <= xor_reduce((code(12) & corr_code));

    data <= corr_code(11) & corr_code(10) & corr_code(9) & corr_code(8) &
            corr_code(6) & corr_code(5) & corr_code(4) & corr_code(2);

    error <= (or_reduce(e) and corr_parity) or (or_reduce(flip_mask(15 downto 13)));


end architecture;