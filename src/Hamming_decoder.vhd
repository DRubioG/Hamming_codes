library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Hamming_decoder is
    port(
        code : in std_logic_vector(12 downto 0);
        data : out std_logic_vector(7 downto 0);
        error : out std_logic
    );
end entity;

architecture arch_Hamming_decoder of Hamming_decoder is

signal e : std_logic_vector(3 downto 0);
signal flip_mask : std_logic_vector(15 downto 0);
signal corr_code : std_logic_vector(11 downto 0);
signal corr_parity : std_logic;

begin

    e(0) <= code(0) xor code(2) xor code(4) xor code(6) xor code(8) xor code(10);
    e(1) <= code(1) xor code(2) xor code(5) xor code(6) xor code(9) xor code(10);
    e(2) <= code(3) xor code(4) xor code(5) xor code(6) xor code(11);
    e(3) <= code(7) xor code(8) xor code(9) xor code(10) xor code(11);

    flip_mask <= (0=>'1', others=>'0') sll e;

    corr_code <= code(11 downto 0) xor flip_mask(12 downto 1);

    corr_parity <= xor_reduce((code(12) & corr_code));

    data <= corr_code(11) & corr_code(10) & corr_code(9) & corr_code(8) &
            corr_code(6) & corr_code(5) & corr_code(4) & corr_code(2);

    error <= (or_reduce(e) and corr_parity) or (or_reduce(flip_mask(15 downto 13)));


end architecture;