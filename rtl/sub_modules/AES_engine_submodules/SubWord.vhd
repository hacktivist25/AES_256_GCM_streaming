library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity SubWord is
	port(
		column : IN std_logic_vector(31 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		output_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end SubWord;

architecture behavior of SubWord is

COMPONENT BRAM_18_true_dual_port is
	port (
		ADDRA : IN std_logic_vector(10 DOWNTO 0);
		ADDRB : IN std_logic_vector(10 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		DOA : OUT std_logic_vector(7 DOWNTO 0);
		DOB : OUT std_logic_vector(7 DOWNTO 0)
	);
end COMPONENT;

begin
BRAM_1 : BRAM_18_true_dual_port PORT MAP (
          ADDRA => "000" & column(31 DOWNTO 24),
	      ADDRB => "000" & column(23 DOWNTO 16),
		  clk => clk,
		  rst => rst,
		  DOA => output_column(31 DOWNTO 24),
		  DOB => output_column(23 DOWNTO 16)
		  );

BRAM_2 : BRAM_18_true_dual_port PORT MAP (
          ADDRA => "000" & column(15 DOWNTO 8),
	      ADDRB => "000" & column(7 DOWNTO 0),
		  clk => clk,
		  rst => rst,
		  DOA => output_column(15 DOWNTO 8),
		  DOB => output_column(7 DOWNTO 0)
		  );
end behavior;