library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SubBytes_8BRAM is
	port (
		state : IN std_logic_vector(127 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end SubBytes_8BRAM;

architecture behavior of SubBytes_8BRAM is
  
COMPONENT BRAM_18_true_dual_port_no_inference is
	port (
		ADDRA : in  std_logic_vector(10 downto 0);
        ADDRB : in  std_logic_vector(10 downto 0);
        clk   : in  std_logic;
        DOA   : out std_logic_vector(7 downto 0);
        DOB   : out std_logic_vector(7 downto 0)
	);
end COMPONENT;
 
type addr_array_t is array (0 to 7) of std_logic_vector(10 downto 0);
signal ADDRA, ADDRB : addr_array_t;

type do_array_t is array (0 to 7) of std_logic_vector(7 downto 0);
signal DOA, DOB : do_array_t;

SIGNAL shift_reg_output : UNSIGNED (127 DOWNTO 0);
				
begin

-- instanciate BRAMs
gen_sbox_bram : for i in 0 to 7 generate
begin
    BRAM_TDP_MACRO_inst : BRAM_18_true_dual_port_no_inference
    port map (
        ADDRA => ADDRA(i),
        ADDRB => ADDRB(i),
        clk => clk,
        DOA => DOA(i),
        DOB => DOB(i)
);
end generate;

process (clk, rst)
    variable shift_reg_output_var : unsigned(127 DOWNTO 0);
	begin
	if rst = '0' then
		shift_reg_output <= (OTHERS => '0');
	elsif rising_edge(clk) then
	   -- LSB to MSB
       ADDRA(0)(7 DOWNTO 0) <= state( 15 DOWNTO 8 );
       ADDRB(0)(7 DOWNTO 0) <= state( 7 DOWNTO 0 );
       ADDRA(1)(7 DOWNTO 0) <= state( 31 DOWNTO 24 );
       ADDRB(1)(7 DOWNTO 0) <= state( 23 DOWNTO 16 );
       ADDRA(2)(7 DOWNTO 0) <= state( 47 DOWNTO 40 );
       ADDRB(2)(7 DOWNTO 0) <= state( 39 DOWNTO 32 );
       ADDRA(3)(7 DOWNTO 0) <= state( 63 DOWNTO 56 );
       ADDRB(3)(7 DOWNTO 0) <= state( 55 DOWNTO 48 );
       ADDRA(4)(7 DOWNTO 0) <= state( 79 DOWNTO 72 );
       ADDRB(4)(7 DOWNTO 0) <= state( 71 DOWNTO 64 );
       ADDRA(5)(7 DOWNTO 0) <= state( 95 DOWNTO 88 );
       ADDRB(5)(7 DOWNTO 0) <= state( 87 DOWNTO 80 );
       ADDRA(6)(7 DOWNTO 0) <= state( 111 DOWNTO 104 );
       ADDRB(6)(7 DOWNTO 0) <= state( 103 DOWNTO 96 );
       ADDRA(7)(7 DOWNTO 0) <= state( 127 DOWNTO 120 );
       ADDRB(7)(7 DOWNTO 0) <= state( 119 DOWNTO 112 );
	end if;
end process;

ADDRA(0) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(0) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(1) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(1) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(2) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(2) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(3) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(3) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(4) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(4) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(5) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(5) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(6) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(6) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRA(7) (10 DOWNTO 8) <= (OTHERS => '0');
ADDRB(7) (10 DOWNTO 8) <= (OTHERS => '0');

output_state <= DOA(7) & DOB(7)
                & DOA(6) & DOB(6)
                & DOA(5) & DOB(5)
                & DOA(4) & DOB(4)
                & DOA(3) & DOB(3)
                & DOA(2) & DOB(2)
                & DOA(1) & DOB(1)
                & DOA(0) & DOB(0);
                

end behavior;