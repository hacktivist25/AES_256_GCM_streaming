library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BRAM_18_true_dual_port_no_inference is
	port (
		ADDRA : IN std_logic_vector(10 DOWNTO 0);
		ADDRB : IN std_logic_vector(10 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		DOA : OUT std_logic_vector(7 DOWNTO 0);
		DOB : OUT std_logic_vector(7 DOWNTO 0)
	);
end BRAM_18_true_dual_port_no_inference;

architecture behavior of BRAM_18_true_dual_port_no_inference is
SIGNAL ADDRA_reg : std_logic_vector(10 DOWNTO 0);
SIGNAL ADDRB_reg : std_logic_vector(10 DOWNTO 0);

begin
process (clk, rst)
begin
    if rst = '0' then
        DOA <= (OTHERS => '0');
        DOB <= (OTHERS => '0');
    elsif rising_edge(clk) then
        ADDRA_reg <= ADDRA;
        ADDRB_reg <= ADDRB;
        
        CASE ADDRA_reg is
			-- SBOX
            WHEN X"00"=>
				DOA <= X"63";

			WHEN X"01"=>
				DOA <= X"7C";

			WHEN X"02"=>
				DOA <= X"77";

			WHEN X"03"=>
				DOA <= X"7B";

			WHEN X"04"=>
				DOA <= X"F2";

			WHEN X"05"=>
				DOA <= X"6B";

			WHEN X"06"=>
				DOA <= X"6F";

			WHEN X"07"=>
				DOA <= X"C5";

			WHEN X"08"=>
				DOA <= X"30";

			WHEN X"09"=>
				DOA <= X"01";

			WHEN X"0A"=>
				DOA <= X"67";

			WHEN X"0B"=>
				DOA <= X"2B";

			WHEN X"0C"=>
				DOA <= X"FE";

			WHEN X"0D"=>
				DOA <= X"D7";

			WHEN X"0E"=>
				DOA <= X"AB";

			WHEN X"0F"=>
				DOA <= X"76";

			WHEN X"10"=>
				DOA <= X"CA";

			WHEN X"11"=>
				DOA <= X"82";

			WHEN X"12"=>
				DOA <= X"C9";

			WHEN X"13"=>
				DOA <= X"7D";

			WHEN X"14"=>
				DOA <= X"FA";

			WHEN X"15"=>
				DOA <= X"59";

			WHEN X"16"=>
				DOA <= X"47";

			WHEN X"17"=>
				DOA <= X"F0";

			WHEN X"18"=>
				DOA <= X"AD";

			WHEN X"19"=>
				DOA <= X"D4";

			WHEN X"1A"=>
				DOA <= X"A2";

			WHEN X"1B"=>
				DOA <= X"AF";

			WHEN X"1C"=>
				DOA <= X"9C";

			WHEN X"1D"=>
				DOA <= X"A4";

			WHEN X"1E"=>
				DOA <= X"72";

			WHEN X"1F"=>
				DOA <= X"C0";

			WHEN X"20"=>
				DOA <= X"B7";

			WHEN X"21"=>
				DOA <= X"FD";

			WHEN X"22"=>
				DOA <= X"93";

			WHEN X"23"=>
				DOA <= X"26";

			WHEN X"24"=>
				DOA <= X"36";

			WHEN X"25"=>
				DOA <= X"3F";

			WHEN X"26"=>
				DOA <= X"F7";

			WHEN X"27"=>
				DOA <= X"CC";

			WHEN X"28"=>
				DOA <= X"34";

			WHEN X"29"=>
				DOA <= X"A5";

			WHEN X"2A"=>
				DOA <= X"E5";

			WHEN X"2B"=>
				DOA <= X"F1";

			WHEN X"2C"=>
				DOA <= X"71";

			WHEN X"2D"=>
				DOA <= X"D8";

			WHEN X"2E"=>
				DOA <= X"31";

			WHEN X"2F"=>
				DOA <= X"15";

			WHEN X"30"=>
				DOA <= X"04";

			WHEN X"31"=>
				DOA <= X"C7";

			WHEN X"32"=>
				DOA <= X"23";

			WHEN X"33"=>
				DOA <= X"C3";

			WHEN X"34"=>
				DOA <= X"18";

			WHEN X"35"=>
				DOA <= X"96";

			WHEN X"36"=>
				DOA <= X"05";

			WHEN X"37"=>
				DOA <= X"9A";

			WHEN X"38"=>
				DOA <= X"07";

			WHEN X"39"=>
				DOA <= X"12";

			WHEN X"3A"=>
				DOA <= X"80";

			WHEN X"3B"=>
				DOA <= X"E2";

			WHEN X"3C"=>
				DOA <= X"EB";

			WHEN X"3D"=>
				DOA <= X"27";

			WHEN X"3E"=>
				DOA <= X"B2";

			WHEN X"3F"=>
				DOA <= X"75";

			WHEN X"40"=>
				DOA <= X"09";

			WHEN X"41"=>
				DOA <= X"83";

			WHEN X"42"=>
				DOA <= X"2C";

			WHEN X"43"=>
				DOA <= X"1A";

			WHEN X"44"=>
				DOA <= X"1B";

			WHEN X"45"=>
				DOA <= X"6E";

			WHEN X"46"=>
				DOA <= X"5A";

			WHEN X"47"=>
				DOA <= X"A0";

			WHEN X"48"=>
				DOA <= X"52";

			WHEN X"49"=>
				DOA <= X"3B";

			WHEN X"4A"=>
				DOA <= X"D6";

			WHEN X"4B"=>
				DOA <= X"B3";

			WHEN X"4C"=>
				DOA <= X"29";

			WHEN X"4D"=>
				DOA <= X"E3";

			WHEN X"4E"=>
				DOA <= X"2F";

			WHEN X"4F"=>
				DOA <= X"84";

			WHEN X"50"=>
				DOA <= X"53";

			WHEN X"51"=>
				DOA <= X"D1";

			WHEN X"52"=>
				DOA <= X"00";

			WHEN X"53"=>
				DOA <= X"ED";

			WHEN X"54"=>
				DOA <= X"20";

			WHEN X"55"=>
				DOA <= X"FC";

			WHEN X"56"=>
				DOA <= X"B1";

			WHEN X"57"=>
				DOA <= X"5B";

			WHEN X"58"=>
				DOA <= X"6A";

			WHEN X"59"=>
				DOA <= X"CB";

			WHEN X"5A"=>
				DOA <= X"BE";

			WHEN X"5B"=>
				DOA <= X"39";

			WHEN X"5C"=>
				DOA <= X"4A";

			WHEN X"5D"=>
				DOA <= X"4C";

			WHEN X"5E"=>
				DOA <= X"58";

			WHEN X"5F"=>
				DOA <= X"CF";

			WHEN X"60"=>
				DOA <= X"D0";

			WHEN X"61"=>
				DOA <= X"EF";

			WHEN X"62"=>
				DOA <= X"AA";

			WHEN X"63"=>
				DOA <= X"FB";

			WHEN X"64"=>
				DOA <= X"43";

			WHEN X"65"=>
				DOA <= X"4D";

			WHEN X"66"=>
				DOA <= X"33";

			WHEN X"67"=>
				DOA <= X"85";

			WHEN X"68"=>
				DOA <= X"45";

			WHEN X"69"=>
				DOA <= X"F9";

			WHEN X"6A"=>
				DOA <= X"02";

			WHEN X"6B"=>
				DOA <= X"7F";

			WHEN X"6C"=>
				DOA <= X"50";

			WHEN X"6D"=>
				DOA <= X"3C";

			WHEN X"6E"=>
				DOA <= X"9F";

			WHEN X"6F"=>
				DOA <= X"A8";

			WHEN X"70"=>
				DOA <= X"51";

			WHEN X"71"=>
				DOA <= X"A3";

			WHEN X"72"=>
				DOA <= X"40";

			WHEN X"73"=>
				DOA <= X"8F";

			WHEN X"74"=>
				DOA <= X"92";

			WHEN X"75"=>
				DOA <= X"9D";

			WHEN X"76"=>
				DOA <= X"38";

			WHEN X"77"=>
				DOA <= X"F5";

			WHEN X"78"=>
				DOA <= X"BC";

			WHEN X"79"=>
				DOA <= X"B6";

			WHEN X"7A"=>
				DOA <= X"DA";

			WHEN X"7B"=>
				DOA <= X"21";

			WHEN X"7C"=>
				DOA <= X"10";

			WHEN X"7D"=>
				DOA <= X"FF";

			WHEN X"7E"=>
				DOA <= X"F3";

			WHEN X"7F"=>
				DOA <= X"D2";

			WHEN X"80"=>
				DOA <= X"CD";

			WHEN X"81"=>
				DOA <= X"0C";

			WHEN X"82"=>
				DOA <= X"13";

			WHEN X"83"=>
				DOA <= X"EC";

			WHEN X"84"=>
				DOA <= X"5F";

			WHEN X"85"=>
				DOA <= X"97";

			WHEN X"86"=>
				DOA <= X"44";

			WHEN X"87"=>
				DOA <= X"17";

			WHEN X"88"=>
				DOA <= X"C4";

			WHEN X"89"=>
				DOA <= X"A7";

			WHEN X"8A"=>
				DOA <= X"7E";

			WHEN X"8B"=>
				DOA <= X"3D";

			WHEN X"8C"=>
				DOA <= X"64";

			WHEN X"8D"=>
				DOA <= X"5D";

			WHEN X"8E"=>
				DOA <= X"19";

			WHEN X"8F"=>
				DOA <= X"73";

			WHEN X"90"=>
				DOA <= X"60";

			WHEN X"91"=>
				DOA <= X"81";

			WHEN X"92"=>
				DOA <= X"4F";

			WHEN X"93"=>
				DOA <= X"DC";

			WHEN X"94"=>
				DOA <= X"22";

			WHEN X"95"=>
				DOA <= X"2A";

			WHEN X"96"=>
				DOA <= X"90";

			WHEN X"97"=>
				DOA <= X"88";

			WHEN X"98"=>
				DOA <= X"46";

			WHEN X"99"=>
				DOA <= X"EE";

			WHEN X"9A"=>
				DOA <= X"B8";

			WHEN X"9B"=>
				DOA <= X"14";

			WHEN X"9C"=>
				DOA <= X"DE";

			WHEN X"9D"=>
				DOA <= X"5E";

			WHEN X"9E"=>
				DOA <= X"0B";

			WHEN X"9F"=>
				DOA <= X"DB";

			WHEN X"A0"=>
				DOA <= X"E0";

			WHEN X"A1"=>
				DOA <= X"32";

			WHEN X"A2"=>
				DOA <= X"3A";

			WHEN X"A3"=>
				DOA <= X"0A";

			WHEN X"A4"=>
				DOA <= X"49";

			WHEN X"A5"=>
				DOA <= X"06";

			WHEN X"A6"=>
				DOA <= X"24";

			WHEN X"A7"=>
				DOA <= X"5C";

			WHEN X"A8"=>
				DOA <= X"C2";

			WHEN X"A9"=>
				DOA <= X"D3";

			WHEN X"AA"=>
				DOA <= X"AC";

			WHEN X"AB"=>
				DOA <= X"62";

			WHEN X"AC"=>
				DOA <= X"91";

			WHEN X"AD"=>
				DOA <= X"95";

			WHEN X"AE"=>
				DOA <= X"E4";

			WHEN X"AF"=>
				DOA <= X"79";

			WHEN X"B0"=>
				DOA <= X"E7";

			WHEN X"B1"=>
				DOA <= X"C8";

			WHEN X"B2"=>
				DOA <= X"37";

			WHEN X"B3"=>
				DOA <= X"6D";

			WHEN X"B4"=>
				DOA <= X"8D";

			WHEN X"B5"=>
				DOA <= X"D5";

			WHEN X"B6"=>
				DOA <= X"4E";

			WHEN X"B7"=>
				DOA <= X"A9";

			WHEN X"B8"=>
				DOA <= X"6C";

			WHEN X"B9"=>
				DOA <= X"56";

			WHEN X"BA"=>
				DOA <= X"F4";

			WHEN X"BB"=>
				DOA <= X"EA";

			WHEN X"BC"=>
				DOA <= X"65";

			WHEN X"BD"=>
				DOA <= X"7A";

			WHEN X"BE"=>
				DOA <= X"AE";

			WHEN X"BF"=>
				DOA <= X"08";

			WHEN X"C0"=>
				DOA <= X"BA";

			WHEN X"C1"=>
				DOA <= X"78";

			WHEN X"C2"=>
				DOA <= X"25";

			WHEN X"C3"=>
				DOA <= X"2E";

			WHEN X"C4"=>
				DOA <= X"1C";

			WHEN X"C5"=>
				DOA <= X"A6";

			WHEN X"C6"=>
				DOA <= X"B4";

			WHEN X"C7"=>
				DOA <= X"C6";

			WHEN X"C8"=>
				DOA <= X"E8";

			WHEN X"C9"=>
				DOA <= X"DD";

			WHEN X"CA"=>
				DOA <= X"74";

			WHEN X"CB"=>
				DOA <= X"1F";

			WHEN X"CC"=>
				DOA <= X"4B";

			WHEN X"CD"=>
				DOA <= X"BD";

			WHEN X"CE"=>
				DOA <= X"8B";

			WHEN X"CF"=>
				DOA <= X"8A";

			WHEN X"D0"=>
				DOA <= X"70";

			WHEN X"D1"=>
				DOA <= X"3E";

			WHEN X"D2"=>
				DOA <= X"B5";

			WHEN X"D3"=>
				DOA <= X"66";

			WHEN X"D4"=>
				DOA <= X"48";

			WHEN X"D5"=>
				DOA <= X"03";

			WHEN X"D6"=>
				DOA <= X"F6";

			WHEN X"D7"=>
				DOA <= X"0E";

			WHEN X"D8"=>
				DOA <= X"61";

			WHEN X"D9"=>
				DOA <= X"35";

			WHEN X"DA"=>
				DOA <= X"57";

			WHEN X"DB"=>
				DOA <= X"B9";

			WHEN X"DC"=>
				DOA <= X"86";

			WHEN X"DD"=>
				DOA <= X"C1";

			WHEN X"DE"=>
				DOA <= X"1D";

			WHEN X"DF"=>
				DOA <= X"9E";

			WHEN X"E0"=>
				DOA <= X"E1";

			WHEN X"E1"=>
				DOA <= X"F8";

			WHEN X"E2"=>
				DOA <= X"98";

			WHEN X"E3"=>
				DOA <= X"11";

			WHEN X"E4"=>
				DOA <= X"69";

			WHEN X"E5"=>
				DOA <= X"D9";

			WHEN X"E6"=>
				DOA <= X"8E";

			WHEN X"E7"=>
				DOA <= X"94";

			WHEN X"E8"=>
				DOA <= X"9B";

			WHEN X"E9"=>
				DOA <= X"1E";

			WHEN X"EA"=>
				DOA <= X"87";

			WHEN X"EB"=>
				DOA <= X"E9";

			WHEN X"EC"=>
				DOA <= X"CE";

			WHEN X"ED"=>
				DOA <= X"55";

			WHEN X"EE"=>
				DOA <= X"28";

			WHEN X"EF"=>
				DOA <= X"DF";

			WHEN X"F0"=>
				DOA <= X"8C";

			WHEN X"F1"=>
				DOA <= X"A1";

			WHEN X"F2"=>
				DOA <= X"89";

			WHEN X"F3"=>
				DOA <= X"0D";

			WHEN X"F4"=>
				DOA <= X"BF";

			WHEN X"F5"=>
				DOA <= X"E6";

			WHEN X"F6"=>
				DOA <= X"42";

			WHEN X"F7"=>
				DOA <= X"68";

			WHEN X"F8"=>
				DOA <= X"41";

			WHEN X"F9"=>
				DOA <= X"99";

			WHEN X"FA"=>
				DOA <= X"2D";

			WHEN X"FB"=>
				DOA <= X"0F";

			WHEN X"FC"=>
				DOA <= X"B0";

			WHEN X"FD"=>
				DOA <= X"54";

			WHEN X"FE"=>
				DOA <= X"BB";

			WHEN X"FF"=>
				DOA <= X"16";
				
				
				
				
			-- INV SBOX
			WHEN X"100"=>
				DOA <= X"52";

			WHEN X"101"=>
				DOA <= X"09";

			WHEN X"102"=>
				DOA <= X"6A";

			WHEN X"103"=>
				DOA <= X"D5";

			WHEN X"104"=>
				DOA <= X"30";

			WHEN X"105"=>
				DOA <= X"36";

			WHEN X"106"=>
				DOA <= X"A5";

			WHEN X"107"=>
				DOA <= X"38";

			WHEN X"108"=>
				DOA <= X"BF";

			WHEN X"109"=>
				DOA <= X"40";

			WHEN X"10A"=>
				DOA <= X"A3";

			WHEN X"10B"=>
				DOA <= X"9E";

			WHEN X"10C"=>
				DOA <= X"81";

			WHEN X"10D"=>
				DOA <= X"F3";

			WHEN X"10E"=>
				DOA <= X"D7";

			WHEN X"10F"=>
				DOA <= X"FB";

			WHEN X"110"=>
				DOA <= X"7C";

			WHEN X"111"=>
				DOA <= X"E3";

			WHEN X"112"=>
				DOA <= X"39";

			WHEN X"113"=>
				DOA <= X"82";

			WHEN X"114"=>
				DOA <= X"9B";

			WHEN X"115"=>
				DOA <= X"2F";

			WHEN X"116"=>
				DOA <= X"FF";

			WHEN X"117"=>
				DOA <= X"87";

			WHEN X"118"=>
				DOA <= X"34";

			WHEN X"119"=>
				DOA <= X"8E";

			WHEN X"11A"=>
				DOA <= X"43";

			WHEN X"11B"=>
				DOA <= X"44";

			WHEN X"11C"=>
				DOA <= X"C4";

			WHEN X"11D"=>
				DOA <= X"DE";

			WHEN X"11E"=>
				DOA <= X"E9";

			WHEN X"11F"=>
				DOA <= X"CB";

			WHEN X"120"=>
				DOA <= X"54";

			WHEN X"121"=>
				DOA <= X"7B";

			WHEN X"122"=>
				DOA <= X"94";

			WHEN X"123"=>
				DOA <= X"32";

			WHEN X"124"=>
				DOA <= X"A6";

			WHEN X"125"=>
				DOA <= X"C2";

			WHEN X"126"=>
				DOA <= X"23";

			WHEN X"127"=>
				DOA <= X"3D";

			WHEN X"128"=>
				DOA <= X"EE";

			WHEN X"129"=>
				DOA <= X"4C";

			WHEN X"12A"=>
				DOA <= X"95";

			WHEN X"12B"=>
				DOA <= X"0B";

			WHEN X"12C"=>
				DOA <= X"42";

			WHEN X"12D"=>
				DOA <= X"FA";

			WHEN X"12E"=>
				DOA <= X"C3";

			WHEN X"12F"=>
				DOA <= X"4E";

			WHEN X"130"=>
				DOA <= X"08";

			WHEN X"131"=>
				DOA <= X"2E";

			WHEN X"132"=>
				DOA <= X"A1";

			WHEN X"133"=>
				DOA <= X"66";

			WHEN X"134"=>
				DOA <= X"28";

			WHEN X"135"=>
				DOA <= X"D9";

			WHEN X"136"=>
				DOA <= X"24";

			WHEN X"137"=>
				DOA <= X"B2";

			WHEN X"138"=>
				DOA <= X"76";

			WHEN X"139"=>
				DOA <= X"5B";

			WHEN X"13A"=>
				DOA <= X"A2";

			WHEN X"13B"=>
				DOA <= X"49";

			WHEN X"13C"=>
				DOA <= X"6D";

			WHEN X"13D"=>
				DOA <= X"8B";

			WHEN X"13E"=>
				DOA <= X"D1";

			WHEN X"13F"=>
				DOA <= X"25";

			WHEN X"140"=>
				DOA <= X"72";

			WHEN X"141"=>
				DOA <= X"F8";

			WHEN X"142"=>
				DOA <= X"F6";

			WHEN X"143"=>
				DOA <= X"64";

			WHEN X"144"=>
				DOA <= X"86";

			WHEN X"145"=>
				DOA <= X"68";

			WHEN X"146"=>
				DOA <= X"98";

			WHEN X"147"=>
				DOA <= X"16";

			WHEN X"148"=>
				DOA <= X"D4";

			WHEN X"149"=>
				DOA <= X"A4";

			WHEN X"14A"=>
				DOA <= X"5C";

			WHEN X"14B"=>
				DOA <= X"CC";

			WHEN X"14C"=>
				DOA <= X"5D";

			WHEN X"14D"=>
				DOA <= X"65";

			WHEN X"14E"=>
				DOA <= X"B6";

			WHEN X"14F"=>
				DOA <= X"92";

			WHEN X"150"=>
				DOA <= X"6C";

			WHEN X"151"=>
				DOA <= X"70";

			WHEN X"152"=>
				DOA <= X"48";

			WHEN X"153"=>
				DOA <= X"50";

			WHEN X"154"=>
				DOA <= X"FD";

			WHEN X"155"=>
				DOA <= X"ED";

			WHEN X"156"=>
				DOA <= X"B9";

			WHEN X"157"=>
				DOA <= X"DA";

			WHEN X"158"=>
				DOA <= X"5E";

			WHEN X"159"=>
				DOA <= X"15";

			WHEN X"15A"=>
				DOA <= X"46";

			WHEN X"15B"=>
				DOA <= X"57";

			WHEN X"15C"=>
				DOA <= X"A7";

			WHEN X"15D"=>
				DOA <= X"8D";

			WHEN X"15E"=>
				DOA <= X"9D";

			WHEN X"15F"=>
				DOA <= X"84";

			WHEN X"160"=>
				DOA <= X"90";

			WHEN X"161"=>
				DOA <= X"D8";

			WHEN X"162"=>
				DOA <= X"AB";

			WHEN X"163"=>
				DOA <= X"00";

			WHEN X"164"=>
				DOA <= X"8C";

			WHEN X"165"=>
				DOA <= X"BC";

			WHEN X"166"=>
				DOA <= X"D3";

			WHEN X"167"=>
				DOA <= X"0A";

			WHEN X"168"=>
				DOA <= X"F7";

			WHEN X"169"=>
				DOA <= X"E4";

			WHEN X"16A"=>
				DOA <= X"58";

			WHEN X"16B"=>
				DOA <= X"05";

			WHEN X"16C"=>
				DOA <= X"B8";

			WHEN X"16D"=>
				DOA <= X"B3";

			WHEN X"16E"=>
				DOA <= X"45";

			WHEN X"16F"=>
				DOA <= X"06";

			WHEN X"170"=>
				DOA <= X"D0";

			WHEN X"171"=>
				DOA <= X"2C";

			WHEN X"172"=>
				DOA <= X"1E";

			WHEN X"173"=>
				DOA <= X"8F";

			WHEN X"174"=>
				DOA <= X"CA";

			WHEN X"175"=>
				DOA <= X"3F";

			WHEN X"176"=>
				DOA <= X"0F";

			WHEN X"177"=>
				DOA <= X"02";

			WHEN X"178"=>
				DOA <= X"C1";

			WHEN X"179"=>
				DOA <= X"AF";

			WHEN X"17A"=>
				DOA <= X"BD";

			WHEN X"17B"=>
				DOA <= X"03";

			WHEN X"17C"=>
				DOA <= X"01";

			WHEN X"17D"=>
				DOA <= X"13";

			WHEN X"17E"=>
				DOA <= X"8A";

			WHEN X"17F"=>
				DOA <= X"6B";

			WHEN X"180"=>
				DOA <= X"3A";

			WHEN X"181"=>
				DOA <= X"91";

			WHEN X"182"=>
				DOA <= X"11";

			WHEN X"183"=>
				DOA <= X"41";

			WHEN X"184"=>
				DOA <= X"4F";

			WHEN X"185"=>
				DOA <= X"67";

			WHEN X"186"=>
				DOA <= X"DC";

			WHEN X"187"=>
				DOA <= X"EA";

			WHEN X"188"=>
				DOA <= X"97";

			WHEN X"189"=>
				DOA <= X"F2";

			WHEN X"18A"=>
				DOA <= X"CF";

			WHEN X"18B"=>
				DOA <= X"CE";

			WHEN X"18C"=>
				DOA <= X"F0";

			WHEN X"18D"=>
				DOA <= X"B4";

			WHEN X"18E"=>
				DOA <= X"E6";

			WHEN X"18F"=>
				DOA <= X"73";

			WHEN X"190"=>
				DOA <= X"96";

			WHEN X"191"=>
				DOA <= X"AC";

			WHEN X"192"=>
				DOA <= X"74";

			WHEN X"193"=>
				DOA <= X"22";

			WHEN X"194"=>
				DOA <= X"E7";

			WHEN X"195"=>
				DOA <= X"AD";

			WHEN X"196"=>
				DOA <= X"35";

			WHEN X"197"=>
				DOA <= X"85";

			WHEN X"198"=>
				DOA <= X"E2";

			WHEN X"199"=>
				DOA <= X"F9";

			WHEN X"19A"=>
				DOA <= X"37";

			WHEN X"19B"=>
				DOA <= X"E8";

			WHEN X"19C"=>
				DOA <= X"1C";

			WHEN X"19D"=>
				DOA <= X"75";

			WHEN X"19E"=>
				DOA <= X"DF";

			WHEN X"19F"=>
				DOA <= X"6E";

			WHEN X"1A0"=>
				DOA <= X"47";

			WHEN X"1A1"=>
				DOA <= X"F1";

			WHEN X"1A2"=>
				DOA <= X"1A";

			WHEN X"1A3"=>
				DOA <= X"71";

			WHEN X"1A4"=>
				DOA <= X"1D";

			WHEN X"1A5"=>
				DOA <= X"29";

			WHEN X"1A6"=>
				DOA <= X"C5";

			WHEN X"1A7"=>
				DOA <= X"89";

			WHEN X"1A8"=>
				DOA <= X"6F";

			WHEN X"1A9"=>
				DOA <= X"B7";

			WHEN X"1AA"=>
				DOA <= X"62";

			WHEN X"1AB"=>
				DOA <= X"0E";

			WHEN X"1AC"=>
				DOA <= X"AA";

			WHEN X"1AD"=>
				DOA <= X"18";

			WHEN X"1AE"=>
				DOA <= X"BE";

			WHEN X"1AF"=>
				DOA <= X"1B";

			WHEN X"1B0"=>
				DOA <= X"FC";

			WHEN X"1B1"=>
				DOA <= X"56";

			WHEN X"1B2"=>
				DOA <= X"3E";

			WHEN X"1B3"=>
				DOA <= X"4B";

			WHEN X"1B4"=>
				DOA <= X"C6";

			WHEN X"1B5"=>
				DOA <= X"D2";

			WHEN X"1B6"=>
				DOA <= X"79";

			WHEN X"1B7"=>
				DOA <= X"20";

			WHEN X"1B8"=>
				DOA <= X"9A";

			WHEN X"1B9"=>
				DOA <= X"DB";

			WHEN X"1BA"=>
				DOA <= X"C0";

			WHEN X"1BB"=>
				DOA <= X"FE";

			WHEN X"1BC"=>
				DOA <= X"78";

			WHEN X"1BD"=>
				DOA <= X"CD";

			WHEN X"1BE"=>
				DOA <= X"5A";

			WHEN X"1BF"=>
				DOA <= X"F4";

			WHEN X"1C0"=>
				DOA <= X"1F";

			WHEN X"1C1"=>
				DOA <= X"DD";

			WHEN X"1C2"=>
				DOA <= X"A8";

			WHEN X"1C3"=>
				DOA <= X"33";

			WHEN X"1C4"=>
				DOA <= X"88";

			WHEN X"1C5"=>
				DOA <= X"07";

			WHEN X"1C6"=>
				DOA <= X"C7";

			WHEN X"1C7"=>
				DOA <= X"31";

			WHEN X"1C8"=>
				DOA <= X"B1";

			WHEN X"1C9"=>
				DOA <= X"12";

			WHEN X"1CA"=>
				DOA <= X"10";

			WHEN X"1CB"=>
				DOA <= X"59";

			WHEN X"1CC"=>
				DOA <= X"27";

			WHEN X"1CD"=>
				DOA <= X"80";

			WHEN X"1CE"=>
				DOA <= X"EC";

			WHEN X"1CF"=>
				DOA <= X"5F";

			WHEN X"1D0"=>
				DOA <= X"60";

			WHEN X"1D1"=>
				DOA <= X"51";

			WHEN X"1D2"=>
				DOA <= X"7F";

			WHEN X"1D3"=>
				DOA <= X"A9";

			WHEN X"1D4"=>
				DOA <= X"19";

			WHEN X"1D5"=>
				DOA <= X"B5";

			WHEN X"1D6"=>
				DOA <= X"4A";

			WHEN X"1D7"=>
				DOA <= X"0D";

			WHEN X"1D8"=>
				DOA <= X"2D";

			WHEN X"1D9"=>
				DOA <= X"E5";

			WHEN X"1DA"=>
				DOA <= X"7A";

			WHEN X"1DB"=>
				DOA <= X"9F";

			WHEN X"1DC"=>
				DOA <= X"93";

			WHEN X"1DD"=>
				DOA <= X"C9";

			WHEN X"1DE"=>
				DOA <= X"9C";

			WHEN X"1DF"=>
				DOA <= X"EF";

			WHEN X"1E0"=>
				DOA <= X"A0";

			WHEN X"1E1"=>
				DOA <= X"E0";

			WHEN X"1E2"=>
				DOA <= X"3B";

			WHEN X"1E3"=>
				DOA <= X"4D";

			WHEN X"1E4"=>
				DOA <= X"AE";

			WHEN X"1E5"=>
				DOA <= X"2A";

			WHEN X"1E6"=>
				DOA <= X"F5";

			WHEN X"1E7"=>
				DOA <= X"B0";

			WHEN X"1E8"=>
				DOA <= X"C8";

			WHEN X"1E9"=>
				DOA <= X"EB";

			WHEN X"1EA"=>
				DOA <= X"BB";

			WHEN X"1EB"=>
				DOA <= X"3C";

			WHEN X"1EC"=>
				DOA <= X"83";

			WHEN X"1ED"=>
				DOA <= X"53";

			WHEN X"1EE"=>
				DOA <= X"99";

			WHEN X"1EF"=>
				DOA <= X"61";

			WHEN X"1F0"=>
				DOA <= X"17";

			WHEN X"1F1"=>
				DOA <= X"2B";

			WHEN X"1F2"=>
				DOA <= X"04";

			WHEN X"1F3"=>
				DOA <= X"7E";

			WHEN X"1F4"=>
				DOA <= X"BA";

			WHEN X"1F5"=>
				DOA <= X"77";

			WHEN X"1F6"=>
				DOA <= X"D6";

			WHEN X"1F7"=>
				DOA <= X"26";

			WHEN X"1F8"=>
				DOA <= X"E1";

			WHEN X"1F9"=>
				DOA <= X"69";

			WHEN X"1FA"=>
				DOA <= X"14";

			WHEN X"1FB"=>
				DOA <= X"63";

			WHEN X"1FC"=>
				DOA <= X"55";

			WHEN X"1FD"=>
				DOA <= X"21";

			WHEN X"1FE"=>
				DOA <= X"0C";

			WHEN X"1FF"=>
				DOA <= X"7D";
			
			WHEN OTHERS =>
				DOA <= X"00";
		END CASE;
		
		
		
		
		
		
		CASE ADDRB is
			-- SBOX
			WHEN X"00"=>
				DOB <= X"63";

			WHEN X"01"=>
				DOB <= X"7C";

			WHEN X"02"=>
				DOB <= X"77";

			WHEN X"03"=>
				DOB <= X"7B";

			WHEN X"04"=>
				DOB <= X"F2";

			WHEN X"05"=>
				DOB <= X"6B";

			WHEN X"06"=>
				DOB <= X"6F";

			WHEN X"07"=>
				DOB <= X"C5";

			WHEN X"08"=>
				DOB <= X"30";

			WHEN X"09"=>
				DOB <= X"01";

			WHEN X"0A"=>
				DOB <= X"67";

			WHEN X"0B"=>
				DOB <= X"2B";

			WHEN X"0C"=>
				DOB <= X"FE";

			WHEN X"0D"=>
				DOB <= X"D7";

			WHEN X"0E"=>
				DOB <= X"AB";

			WHEN X"0F"=>
				DOB <= X"76";

			WHEN X"10"=>
				DOB <= X"CA";

			WHEN X"11"=>
				DOB <= X"82";

			WHEN X"12"=>
				DOB <= X"C9";

			WHEN X"13"=>
				DOB <= X"7D";

			WHEN X"14"=>
				DOB <= X"FA";

			WHEN X"15"=>
				DOB <= X"59";

			WHEN X"16"=>
				DOB <= X"47";

			WHEN X"17"=>
				DOB <= X"F0";

			WHEN X"18"=>
				DOB <= X"AD";

			WHEN X"19"=>
				DOB <= X"D4";

			WHEN X"1A"=>
				DOB <= X"A2";

			WHEN X"1B"=>
				DOB <= X"AF";

			WHEN X"1C"=>
				DOB <= X"9C";

			WHEN X"1D"=>
				DOB <= X"A4";

			WHEN X"1E"=>
				DOB <= X"72";

			WHEN X"1F"=>
				DOB <= X"C0";

			WHEN X"20"=>
				DOB <= X"B7";

			WHEN X"21"=>
				DOB <= X"FD";

			WHEN X"22"=>
				DOB <= X"93";

			WHEN X"23"=>
				DOB <= X"26";

			WHEN X"24"=>
				DOB <= X"36";

			WHEN X"25"=>
				DOB <= X"3F";

			WHEN X"26"=>
				DOB <= X"F7";

			WHEN X"27"=>
				DOB <= X"CC";

			WHEN X"28"=>
				DOB <= X"34";

			WHEN X"29"=>
				DOB <= X"A5";

			WHEN X"2A"=>
				DOB <= X"E5";

			WHEN X"2B"=>
				DOB <= X"F1";

			WHEN X"2C"=>
				DOB <= X"71";

			WHEN X"2D"=>
				DOB <= X"D8";

			WHEN X"2E"=>
				DOB <= X"31";

			WHEN X"2F"=>
				DOB <= X"15";

			WHEN X"30"=>
				DOB <= X"04";

			WHEN X"31"=>
				DOB <= X"C7";

			WHEN X"32"=>
				DOB <= X"23";

			WHEN X"33"=>
				DOB <= X"C3";

			WHEN X"34"=>
				DOB <= X"18";

			WHEN X"35"=>
				DOB <= X"96";

			WHEN X"36"=>
				DOB <= X"05";

			WHEN X"37"=>
				DOB <= X"9A";

			WHEN X"38"=>
				DOB <= X"07";

			WHEN X"39"=>
				DOB <= X"12";

			WHEN X"3A"=>
				DOB <= X"80";

			WHEN X"3B"=>
				DOB <= X"E2";

			WHEN X"3C"=>
				DOB <= X"EB";

			WHEN X"3D"=>
				DOB <= X"27";

			WHEN X"3E"=>
				DOB <= X"B2";

			WHEN X"3F"=>
				DOB <= X"75";

			WHEN X"40"=>
				DOB <= X"09";

			WHEN X"41"=>
				DOB <= X"83";

			WHEN X"42"=>
				DOB <= X"2C";

			WHEN X"43"=>
				DOB <= X"1A";

			WHEN X"44"=>
				DOB <= X"1B";

			WHEN X"45"=>
				DOB <= X"6E";

			WHEN X"46"=>
				DOB <= X"5A";

			WHEN X"47"=>
				DOB <= X"A0";

			WHEN X"48"=>
				DOB <= X"52";

			WHEN X"49"=>
				DOB <= X"3B";

			WHEN X"4A"=>
				DOB <= X"D6";

			WHEN X"4B"=>
				DOB <= X"B3";

			WHEN X"4C"=>
				DOB <= X"29";

			WHEN X"4D"=>
				DOB <= X"E3";

			WHEN X"4E"=>
				DOB <= X"2F";

			WHEN X"4F"=>
				DOB <= X"84";

			WHEN X"50"=>
				DOB <= X"53";

			WHEN X"51"=>
				DOB <= X"D1";

			WHEN X"52"=>
				DOB <= X"00";

			WHEN X"53"=>
				DOB <= X"ED";

			WHEN X"54"=>
				DOB <= X"20";

			WHEN X"55"=>
				DOB <= X"FC";

			WHEN X"56"=>
				DOB <= X"B1";

			WHEN X"57"=>
				DOB <= X"5B";

			WHEN X"58"=>
				DOB <= X"6A";

			WHEN X"59"=>
				DOB <= X"CB";

			WHEN X"5A"=>
				DOB <= X"BE";

			WHEN X"5B"=>
				DOB <= X"39";

			WHEN X"5C"=>
				DOB <= X"4A";

			WHEN X"5D"=>
				DOB <= X"4C";

			WHEN X"5E"=>
				DOB <= X"58";

			WHEN X"5F"=>
				DOB <= X"CF";

			WHEN X"60"=>
				DOB <= X"D0";

			WHEN X"61"=>
				DOB <= X"EF";

			WHEN X"62"=>
				DOB <= X"AA";

			WHEN X"63"=>
				DOB <= X"FB";

			WHEN X"64"=>
				DOB <= X"43";

			WHEN X"65"=>
				DOB <= X"4D";

			WHEN X"66"=>
				DOB <= X"33";

			WHEN X"67"=>
				DOB <= X"85";

			WHEN X"68"=>
				DOB <= X"45";

			WHEN X"69"=>
				DOB <= X"F9";

			WHEN X"6A"=>
				DOB <= X"02";

			WHEN X"6B"=>
				DOB <= X"7F";

			WHEN X"6C"=>
				DOB <= X"50";

			WHEN X"6D"=>
				DOB <= X"3C";

			WHEN X"6E"=>
				DOB <= X"9F";

			WHEN X"6F"=>
				DOB <= X"A8";

			WHEN X"70"=>
				DOB <= X"51";

			WHEN X"71"=>
				DOB <= X"A3";

			WHEN X"72"=>
				DOB <= X"40";

			WHEN X"73"=>
				DOB <= X"8F";

			WHEN X"74"=>
				DOB <= X"92";

			WHEN X"75"=>
				DOB <= X"9D";

			WHEN X"76"=>
				DOB <= X"38";

			WHEN X"77"=>
				DOB <= X"F5";

			WHEN X"78"=>
				DOB <= X"BC";

			WHEN X"79"=>
				DOB <= X"B6";

			WHEN X"7A"=>
				DOB <= X"DA";

			WHEN X"7B"=>
				DOB <= X"21";

			WHEN X"7C"=>
				DOB <= X"10";

			WHEN X"7D"=>
				DOB <= X"FF";

			WHEN X"7E"=>
				DOB <= X"F3";

			WHEN X"7F"=>
				DOB <= X"D2";

			WHEN X"80"=>
				DOB <= X"CD";

			WHEN X"81"=>
				DOB <= X"0C";

			WHEN X"82"=>
				DOB <= X"13";

			WHEN X"83"=>
				DOB <= X"EC";

			WHEN X"84"=>
				DOB <= X"5F";

			WHEN X"85"=>
				DOB <= X"97";

			WHEN X"86"=>
				DOB <= X"44";

			WHEN X"87"=>
				DOB <= X"17";

			WHEN X"88"=>
				DOB <= X"C4";

			WHEN X"89"=>
				DOB <= X"A7";

			WHEN X"8A"=>
				DOB <= X"7E";

			WHEN X"8B"=>
				DOB <= X"3D";

			WHEN X"8C"=>
				DOB <= X"64";

			WHEN X"8D"=>
				DOB <= X"5D";

			WHEN X"8E"=>
				DOB <= X"19";

			WHEN X"8F"=>
				DOB <= X"73";

			WHEN X"90"=>
				DOB <= X"60";

			WHEN X"91"=>
				DOB <= X"81";

			WHEN X"92"=>
				DOB <= X"4F";

			WHEN X"93"=>
				DOB <= X"DC";

			WHEN X"94"=>
				DOB <= X"22";

			WHEN X"95"=>
				DOB <= X"2A";

			WHEN X"96"=>
				DOB <= X"90";

			WHEN X"97"=>
				DOB <= X"88";

			WHEN X"98"=>
				DOB <= X"46";

			WHEN X"99"=>
				DOB <= X"EE";

			WHEN X"9A"=>
				DOB <= X"B8";

			WHEN X"9B"=>
				DOB <= X"14";

			WHEN X"9C"=>
				DOB <= X"DE";

			WHEN X"9D"=>
				DOB <= X"5E";

			WHEN X"9E"=>
				DOB <= X"0B";

			WHEN X"9F"=>
				DOB <= X"DB";

			WHEN X"A0"=>
				DOB <= X"E0";

			WHEN X"A1"=>
				DOB <= X"32";

			WHEN X"A2"=>
				DOB <= X"3A";

			WHEN X"A3"=>
				DOB <= X"0A";

			WHEN X"A4"=>
				DOB <= X"49";

			WHEN X"A5"=>
				DOB <= X"06";

			WHEN X"A6"=>
				DOB <= X"24";

			WHEN X"A7"=>
				DOB <= X"5C";

			WHEN X"A8"=>
				DOB <= X"C2";

			WHEN X"A9"=>
				DOB <= X"D3";

			WHEN X"AA"=>
				DOB <= X"AC";

			WHEN X"AB"=>
				DOB <= X"62";

			WHEN X"AC"=>
				DOB <= X"91";

			WHEN X"AD"=>
				DOB <= X"95";

			WHEN X"AE"=>
				DOB <= X"E4";

			WHEN X"AF"=>
				DOB <= X"79";

			WHEN X"B0"=>
				DOB <= X"E7";

			WHEN X"B1"=>
				DOB <= X"C8";

			WHEN X"B2"=>
				DOB <= X"37";

			WHEN X"B3"=>
				DOB <= X"6D";

			WHEN X"B4"=>
				DOB <= X"8D";

			WHEN X"B5"=>
				DOB <= X"D5";

			WHEN X"B6"=>
				DOB <= X"4E";

			WHEN X"B7"=>
				DOB <= X"A9";

			WHEN X"B8"=>
				DOB <= X"6C";

			WHEN X"B9"=>
				DOB <= X"56";

			WHEN X"BA"=>
				DOB <= X"F4";

			WHEN X"BB"=>
				DOB <= X"EA";

			WHEN X"BC"=>
				DOB <= X"65";

			WHEN X"BD"=>
				DOB <= X"7A";

			WHEN X"BE"=>
				DOB <= X"AE";

			WHEN X"BF"=>
				DOB <= X"08";

			WHEN X"C0"=>
				DOB <= X"BA";

			WHEN X"C1"=>
				DOB <= X"78";

			WHEN X"C2"=>
				DOB <= X"25";

			WHEN X"C3"=>
				DOB <= X"2E";

			WHEN X"C4"=>
				DOB <= X"1C";

			WHEN X"C5"=>
				DOB <= X"A6";

			WHEN X"C6"=>
				DOB <= X"B4";

			WHEN X"C7"=>
				DOB <= X"C6";

			WHEN X"C8"=>
				DOB <= X"E8";

			WHEN X"C9"=>
				DOB <= X"DD";

			WHEN X"CA"=>
				DOB <= X"74";

			WHEN X"CB"=>
				DOB <= X"1F";

			WHEN X"CC"=>
				DOB <= X"4B";

			WHEN X"CD"=>
				DOB <= X"BD";

			WHEN X"CE"=>
				DOB <= X"8B";

			WHEN X"CF"=>
				DOB <= X"8A";

			WHEN X"D0"=>
				DOB <= X"70";

			WHEN X"D1"=>
				DOB <= X"3E";

			WHEN X"D2"=>
				DOB <= X"B5";

			WHEN X"D3"=>
				DOB <= X"66";

			WHEN X"D4"=>
				DOB <= X"48";

			WHEN X"D5"=>
				DOB <= X"03";

			WHEN X"D6"=>
				DOB <= X"F6";

			WHEN X"D7"=>
				DOB <= X"0E";

			WHEN X"D8"=>
				DOB <= X"61";

			WHEN X"D9"=>
				DOB <= X"35";

			WHEN X"DA"=>
				DOB <= X"57";

			WHEN X"DB"=>
				DOB <= X"B9";

			WHEN X"DC"=>
				DOB <= X"86";

			WHEN X"DD"=>
				DOB <= X"C1";

			WHEN X"DE"=>
				DOB <= X"1D";

			WHEN X"DF"=>
				DOB <= X"9E";

			WHEN X"E0"=>
				DOB <= X"E1";

			WHEN X"E1"=>
				DOB <= X"F8";

			WHEN X"E2"=>
				DOB <= X"98";

			WHEN X"E3"=>
				DOB <= X"11";

			WHEN X"E4"=>
				DOB <= X"69";

			WHEN X"E5"=>
				DOB <= X"D9";

			WHEN X"E6"=>
				DOB <= X"8E";

			WHEN X"E7"=>
				DOB <= X"94";

			WHEN X"E8"=>
				DOB <= X"9B";

			WHEN X"E9"=>
				DOB <= X"1E";

			WHEN X"EA"=>
				DOB <= X"87";

			WHEN X"EB"=>
				DOB <= X"E9";

			WHEN X"EC"=>
				DOB <= X"CE";

			WHEN X"ED"=>
				DOB <= X"55";

			WHEN X"EE"=>
				DOB <= X"28";

			WHEN X"EF"=>
				DOB <= X"DF";

			WHEN X"F0"=>
				DOB <= X"8C";

			WHEN X"F1"=>
				DOB <= X"A1";

			WHEN X"F2"=>
				DOB <= X"89";

			WHEN X"F3"=>
				DOB <= X"0D";

			WHEN X"F4"=>
				DOB <= X"BF";

			WHEN X"F5"=>
				DOB <= X"E6";

			WHEN X"F6"=>
				DOB <= X"42";

			WHEN X"F7"=>
				DOB <= X"68";

			WHEN X"F8"=>
				DOB <= X"41";

			WHEN X"F9"=>
				DOB <= X"99";

			WHEN X"FA"=>
				DOB <= X"2D";

			WHEN X"FB"=>
				DOB <= X"0F";

			WHEN X"FC"=>
				DOB <= X"B0";

			WHEN X"FD"=>
				DOB <= X"54";

			WHEN X"FE"=>
				DOB <= X"BB";

			WHEN X"FF"=>
				DOB <= X"16";
				
				
				
				
			-- INV_SBOX
			WHEN X"100"=>
				DOB <= X"52";

			WHEN X"101"=>
				DOB <= X"09";

			WHEN X"102"=>
				DOB <= X"6A";

			WHEN X"103"=>
				DOB <= X"D5";

			WHEN X"104"=>
				DOB <= X"30";

			WHEN X"105"=>
				DOB <= X"36";

			WHEN X"106"=>
				DOB <= X"A5";

			WHEN X"107"=>
				DOB <= X"38";

			WHEN X"108"=>
				DOB <= X"BF";

			WHEN X"109"=>
				DOB <= X"40";

			WHEN X"10A"=>
				DOB <= X"A3";

			WHEN X"10B"=>
				DOB <= X"9E";

			WHEN X"10C"=>
				DOB <= X"81";

			WHEN X"10D"=>
				DOB <= X"F3";

			WHEN X"10E"=>
				DOB <= X"D7";

			WHEN X"10F"=>
				DOB <= X"FB";

			WHEN X"110"=>
				DOB <= X"7C";

			WHEN X"111"=>
				DOB <= X"E3";

			WHEN X"112"=>
				DOB <= X"39";

			WHEN X"113"=>
				DOB <= X"82";

			WHEN X"114"=>
				DOB <= X"9B";

			WHEN X"115"=>
				DOB <= X"2F";

			WHEN X"116"=>
				DOB <= X"FF";

			WHEN X"117"=>
				DOB <= X"87";

			WHEN X"118"=>
				DOB <= X"34";

			WHEN X"119"=>
				DOB <= X"8E";

			WHEN X"11A"=>
				DOB <= X"43";

			WHEN X"11B"=>
				DOB <= X"44";

			WHEN X"11C"=>
				DOB <= X"C4";

			WHEN X"11D"=>
				DOB <= X"DE";

			WHEN X"11E"=>
				DOB <= X"E9";

			WHEN X"11F"=>
				DOB <= X"CB";

			WHEN X"120"=>
				DOB <= X"54";

			WHEN X"121"=>
				DOB <= X"7B";

			WHEN X"122"=>
				DOB <= X"94";

			WHEN X"123"=>
				DOB <= X"32";

			WHEN X"124"=>
				DOB <= X"A6";

			WHEN X"125"=>
				DOB <= X"C2";

			WHEN X"126"=>
				DOB <= X"23";

			WHEN X"127"=>
				DOB <= X"3D";

			WHEN X"128"=>
				DOB <= X"EE";

			WHEN X"129"=>
				DOB <= X"4C";

			WHEN X"12A"=>
				DOB <= X"95";

			WHEN X"12B"=>
				DOB <= X"0B";

			WHEN X"12C"=>
				DOB <= X"42";

			WHEN X"12D"=>
				DOB <= X"FA";

			WHEN X"12E"=>
				DOB <= X"C3";

			WHEN X"12F"=>
				DOB <= X"4E";

			WHEN X"130"=>
				DOB <= X"08";

			WHEN X"131"=>
				DOB <= X"2E";

			WHEN X"132"=>
				DOB <= X"A1";

			WHEN X"133"=>
				DOB <= X"66";

			WHEN X"134"=>
				DOB <= X"28";

			WHEN X"135"=>
				DOB <= X"D9";

			WHEN X"136"=>
				DOB <= X"24";

			WHEN X"137"=>
				DOB <= X"B2";

			WHEN X"138"=>
				DOB <= X"76";

			WHEN X"139"=>
				DOB <= X"5B";

			WHEN X"13A"=>
				DOB <= X"A2";

			WHEN X"13B"=>
				DOB <= X"49";

			WHEN X"13C"=>
				DOB <= X"6D";

			WHEN X"13D"=>
				DOB <= X"8B";

			WHEN X"13E"=>
				DOB <= X"D1";

			WHEN X"13F"=>
				DOB <= X"25";

			WHEN X"140"=>
				DOB <= X"72";

			WHEN X"141"=>
				DOB <= X"F8";

			WHEN X"142"=>
				DOB <= X"F6";

			WHEN X"143"=>
				DOB <= X"64";

			WHEN X"144"=>
				DOB <= X"86";

			WHEN X"145"=>
				DOB <= X"68";

			WHEN X"146"=>
				DOB <= X"98";

			WHEN X"147"=>
				DOB <= X"16";

			WHEN X"148"=>
				DOB <= X"D4";

			WHEN X"149"=>
				DOB <= X"A4";

			WHEN X"14A"=>
				DOB <= X"5C";

			WHEN X"14B"=>
				DOB <= X"CC";

			WHEN X"14C"=>
				DOB <= X"5D";

			WHEN X"14D"=>
				DOB <= X"65";

			WHEN X"14E"=>
				DOB <= X"B6";

			WHEN X"14F"=>
				DOB <= X"92";

			WHEN X"150"=>
				DOB <= X"6C";

			WHEN X"151"=>
				DOB <= X"70";

			WHEN X"152"=>
				DOB <= X"48";

			WHEN X"153"=>
				DOB <= X"50";

			WHEN X"154"=>
				DOB <= X"FD";

			WHEN X"155"=>
				DOB <= X"ED";

			WHEN X"156"=>
				DOB <= X"B9";

			WHEN X"157"=>
				DOB <= X"DA";

			WHEN X"158"=>
				DOB <= X"5E";

			WHEN X"159"=>
				DOB <= X"15";

			WHEN X"15A"=>
				DOB <= X"46";

			WHEN X"15B"=>
				DOB <= X"57";

			WHEN X"15C"=>
				DOB <= X"A7";

			WHEN X"15D"=>
				DOB <= X"8D";

			WHEN X"15E"=>
				DOB <= X"9D";

			WHEN X"15F"=>
				DOB <= X"84";

			WHEN X"160"=>
				DOB <= X"90";

			WHEN X"161"=>
				DOB <= X"D8";

			WHEN X"162"=>
				DOB <= X"AB";

			WHEN X"163"=>
				DOB <= X"00";

			WHEN X"164"=>
				DOB <= X"8C";

			WHEN X"165"=>
				DOB <= X"BC";

			WHEN X"166"=>
				DOB <= X"D3";

			WHEN X"167"=>
				DOB <= X"0A";

			WHEN X"168"=>
				DOB <= X"F7";

			WHEN X"169"=>
				DOB <= X"E4";

			WHEN X"16A"=>
				DOB <= X"58";

			WHEN X"16B"=>
				DOB <= X"05";

			WHEN X"16C"=>
				DOB <= X"B8";

			WHEN X"16D"=>
				DOB <= X"B3";

			WHEN X"16E"=>
				DOB <= X"45";

			WHEN X"16F"=>
				DOB <= X"06";

			WHEN X"170"=>
				DOB <= X"D0";

			WHEN X"171"=>
				DOB <= X"2C";

			WHEN X"172"=>
				DOB <= X"1E";

			WHEN X"173"=>
				DOB <= X"8F";

			WHEN X"174"=>
				DOB <= X"CA";

			WHEN X"175"=>
				DOB <= X"3F";

			WHEN X"176"=>
				DOB <= X"0F";

			WHEN X"177"=>
				DOB <= X"02";

			WHEN X"178"=>
				DOB <= X"C1";

			WHEN X"179"=>
				DOB <= X"AF";

			WHEN X"17A"=>
				DOB <= X"BD";

			WHEN X"17B"=>
				DOB <= X"03";

			WHEN X"17C"=>
				DOB <= X"01";

			WHEN X"17D"=>
				DOB <= X"13";

			WHEN X"17E"=>
				DOB <= X"8A";

			WHEN X"17F"=>
				DOB <= X"6B";

			WHEN X"180"=>
				DOB <= X"3A";

			WHEN X"181"=>
				DOB <= X"91";

			WHEN X"182"=>
				DOB <= X"11";

			WHEN X"183"=>
				DOB <= X"41";

			WHEN X"184"=>
				DOB <= X"4F";

			WHEN X"185"=>
				DOB <= X"67";

			WHEN X"186"=>
				DOB <= X"DC";

			WHEN X"187"=>
				DOB <= X"EA";

			WHEN X"188"=>
				DOB <= X"97";

			WHEN X"189"=>
				DOB <= X"F2";

			WHEN X"18A"=>
				DOB <= X"CF";

			WHEN X"18B"=>
				DOB <= X"CE";

			WHEN X"18C"=>
				DOB <= X"F0";

			WHEN X"18D"=>
				DOB <= X"B4";

			WHEN X"18E"=>
				DOB <= X"E6";

			WHEN X"18F"=>
				DOB <= X"73";

			WHEN X"190"=>
				DOB <= X"96";

			WHEN X"191"=>
				DOB <= X"AC";

			WHEN X"192"=>
				DOB <= X"74";

			WHEN X"193"=>
				DOB <= X"22";

			WHEN X"194"=>
				DOB <= X"E7";

			WHEN X"195"=>
				DOB <= X"AD";

			WHEN X"196"=>
				DOB <= X"35";

			WHEN X"197"=>
				DOB <= X"85";

			WHEN X"198"=>
				DOB <= X"E2";

			WHEN X"199"=>
				DOB <= X"F9";

			WHEN X"19A"=>
				DOB <= X"37";

			WHEN X"19B"=>
				DOB <= X"E8";

			WHEN X"19C"=>
				DOB <= X"1C";

			WHEN X"19D"=>
				DOB <= X"75";

			WHEN X"19E"=>
				DOB <= X"DF";

			WHEN X"19F"=>
				DOB <= X"6E";

			WHEN X"1A0"=>
				DOB <= X"47";

			WHEN X"1A1"=>
				DOB <= X"F1";

			WHEN X"1A2"=>
				DOB <= X"1A";

			WHEN X"1A3"=>
				DOB <= X"71";

			WHEN X"1A4"=>
				DOB <= X"1D";

			WHEN X"1A5"=>
				DOB <= X"29";

			WHEN X"1A6"=>
				DOB <= X"C5";

			WHEN X"1A7"=>
				DOB <= X"89";

			WHEN X"1A8"=>
				DOB <= X"6F";

			WHEN X"1A9"=>
				DOB <= X"B7";

			WHEN X"1AA"=>
				DOB <= X"62";

			WHEN X"1AB"=>
				DOB <= X"0E";

			WHEN X"1AC"=>
				DOB <= X"AA";

			WHEN X"1AD"=>
				DOB <= X"18";

			WHEN X"1AE"=>
				DOB <= X"BE";

			WHEN X"1AF"=>
				DOB <= X"1B";

			WHEN X"1B0"=>
				DOB <= X"FC";

			WHEN X"1B1"=>
				DOB <= X"56";

			WHEN X"1B2"=>
				DOB <= X"3E";

			WHEN X"1B3"=>
				DOB <= X"4B";

			WHEN X"1B4"=>
				DOB <= X"C6";

			WHEN X"1B5"=>
				DOB <= X"D2";

			WHEN X"1B6"=>
				DOB <= X"79";

			WHEN X"1B7"=>
				DOB <= X"20";

			WHEN X"1B8"=>
				DOB <= X"9A";

			WHEN X"1B9"=>
				DOB <= X"DB";

			WHEN X"1BA"=>
				DOB <= X"C0";

			WHEN X"1BB"=>
				DOB <= X"FE";

			WHEN X"1BC"=>
				DOB <= X"78";

			WHEN X"1BD"=>
				DOB <= X"CD";

			WHEN X"1BE"=>
				DOB <= X"5A";

			WHEN X"1BF"=>
				DOB <= X"F4";

			WHEN X"1C0"=>
				DOB <= X"1F";

			WHEN X"1C1"=>
				DOB <= X"DD";

			WHEN X"1C2"=>
				DOB <= X"A8";

			WHEN X"1C3"=>
				DOB <= X"33";

			WHEN X"1C4"=>
				DOB <= X"88";

			WHEN X"1C5"=>
				DOB <= X"07";

			WHEN X"1C6"=>
				DOB <= X"C7";

			WHEN X"1C7"=>
				DOB <= X"31";

			WHEN X"1C8"=>
				DOB <= X"B1";

			WHEN X"1C9"=>
				DOB <= X"12";

			WHEN X"1CA"=>
				DOB <= X"10";

			WHEN X"1CB"=>
				DOB <= X"59";

			WHEN X"1CC"=>
				DOB <= X"27";

			WHEN X"1CD"=>
				DOB <= X"80";

			WHEN X"1CE"=>
				DOB <= X"EC";

			WHEN X"1CF"=>
				DOB <= X"5F";

			WHEN X"1D0"=>
				DOB <= X"60";

			WHEN X"1D1"=>
				DOB <= X"51";

			WHEN X"1D2"=>
				DOB <= X"7F";

			WHEN X"1D3"=>
				DOB <= X"A9";

			WHEN X"1D4"=>
				DOB <= X"19";

			WHEN X"1D5"=>
				DOB <= X"B5";

			WHEN X"1D6"=>
				DOB <= X"4A";

			WHEN X"1D7"=>
				DOB <= X"0D";

			WHEN X"1D8"=>
				DOB <= X"2D";

			WHEN X"1D9"=>
				DOB <= X"E5";

			WHEN X"1DA"=>
				DOB <= X"7A";

			WHEN X"1DB"=>
				DOB <= X"9F";

			WHEN X"1DC"=>
				DOB <= X"93";

			WHEN X"1DD"=>
				DOB <= X"C9";

			WHEN X"1DE"=>
				DOB <= X"9C";

			WHEN X"1DF"=>
				DOB <= X"EF";

			WHEN X"1E0"=>
				DOB <= X"A0";

			WHEN X"1E1"=>
				DOB <= X"E0";

			WHEN X"1E2"=>
				DOB <= X"3B";

			WHEN X"1E3"=>
				DOB <= X"4D";

			WHEN X"1E4"=>
				DOB <= X"AE";

			WHEN X"1E5"=>
				DOB <= X"2A";

			WHEN X"1E6"=>
				DOB <= X"F5";

			WHEN X"1E7"=>
				DOB <= X"B0";

			WHEN X"1E8"=>
				DOB <= X"C8";

			WHEN X"1E9"=>
				DOB <= X"EB";

			WHEN X"1EA"=>
				DOB <= X"BB";

			WHEN X"1EB"=>
				DOB <= X"3C";

			WHEN X"1EC"=>
				DOB <= X"83";

			WHEN X"1ED"=>
				DOB <= X"53";

			WHEN X"1EE"=>
				DOB <= X"99";

			WHEN X"1EF"=>
				DOB <= X"61";

			WHEN X"1F0"=>
				DOB <= X"17";

			WHEN X"1F1"=>
				DOB <= X"2B";

			WHEN X"1F2"=>
				DOB <= X"04";

			WHEN X"1F3"=>
				DOB <= X"7E";

			WHEN X"1F4"=>
				DOB <= X"BA";

			WHEN X"1F5"=>
				DOB <= X"77";

			WHEN X"1F6"=>
				DOB <= X"D6";

			WHEN X"1F7"=>
				DOB <= X"26";

			WHEN X"1F8"=>
				DOB <= X"E1";

			WHEN X"1F9"=>
				DOB <= X"69";

			WHEN X"1FA"=>
				DOB <= X"14";

			WHEN X"1FB"=>
				DOB <= X"63";

			WHEN X"1FC"=>
				DOB <= X"55";

			WHEN X"1FD"=>
				DOB <= X"21";

			WHEN X"1FE"=>
				DOB <= X"0C";

			WHEN X"1FF"=>
				DOB <= X"7D";
			
			WHEN OTHERS =>
				DOB <= X"00";
		END CASE;
    end if;
end process;

end behavior;