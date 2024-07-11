library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Hamming_encoder is
    port(
        data : in std_logic_vector(7 downto 0);
        code : out std_logic_vector(12 downto 0)
    );
end entity;

architecture arch_Hamming_encoder of Hamming_encoder is

signal p1, p2, p3, p4 : std_logic;
signal hamming_code : std_logic_vector(11 downto 0);
signal parity : std_logic;

begin

    p1 <= data(0) xor data(1) xor data(3) xor data(4) xor data(6);
    p2 <= data(0) xor data(2) xor data(3) xor data(5) xor data(6);
    p3 <= data(1) xor data(2) xor data(3) xor data(7);
    p4 <= data(4) xor data(5) xor data(6) xor data(7);

    hamming_code <= data(7) & data(6) & data(5) & data(4) & p4 & data(3) & 
                    data(2) & data(1) & p4 & data(0) & p2 & p1;
    

    parity <= xor_reduce(hamming_code);

    code <= parity & hamming_code;

end architecture;