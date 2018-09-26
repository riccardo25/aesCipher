----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:08:44 09/22/2018 
-- Design Name: 
-- Module Name:    cipher - arc 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cipher is

	port (
				--INPUT
					CLK, rst_n 							: in std_logic;
					--data									: in std_logic_vector (127 downto 0);
					--key									: in std_logic_vector (255 downto 0);
					key_lenght							: in std_logic_vector (1 downto 0);
					enc									: in std_logic;
				--OUTPUT
					valid_out							: out std_logic;
					crypted_data						: out std_logic_vector (127 downto 0)
				);
	end cipher;

architecture arc of cipher is

	
	--signal data	: std_logic_vector (127 downto 0) := X"3243f6a8885a308d313198a2e0370734";
	--signal data	: std_logic_vector (127 downto 0) := X"69c4e0d86a7b0430d8cdb78070b4c55a";
	
	--signal data	: std_logic_vector (127 downto 0) := X"3925841d02dc09fbdc118597196a0b32";
	--signal key 	: std_logic_vector (255 downto 0) := X"00000000000000000000000000000000" & X"09cf4f3c" & X"abf71588" & X"28aed2a6"& X"2b7e1516";
	
	signal data	: std_logic_vector (127 downto 0) := X"8ea2b7ca516745bfeafc49904b496089";--X"00112233445566778899aabbccddeeff";--X"dda97ca4864cdfe06eaf70a0ec0d7191";--
	--signal key 	: std_logic_vector (255 downto 0) := X"00000000000000000000000000000000" &  X"0c0d0e0f08090a0b0405060700010203";
	--signal key 	: std_logic_vector (255 downto 0) := X"0000000000000000" &  X"14151617101112130c0d0e0f08090a0b0405060700010203";
	signal key 	: std_logic_vector (255 downto 0) := X"1C1D1E1F18191A1B" &  X"14151617101112130c0d0e0f08090a0b0405060700010203";

	component dataunit is

		port (
				--INPUT
				CLK, rst_n 							: in std_logic;
				keywords								: in std_logic_vector (127 downto 0);
				in0, in1, in2, in3				: in std_logic_vector (7 downto 0);
				key_lenght							: in std_logic_vector (1 downto 0);
				enc									: in std_logic;
				key_valid							: in std_logic;
				--OUTPUT
				loading								: out std_logic;
				ROUND									: out std_logic_vector (3 downto 0);
				data_out0, data_out1,
				data_out2, data_out3				: out std_logic_vector (7 downto 0);
				valid_out							: out std_logic
				
			);
	end component;
	
	
	component key_generator is

		port(
			CLK, rst_n 		: in std_logic;
			-- INPUT
			key 				: in std_logic_vector (255 downto 0);
			key_len 			: in std_logic_vector (1 downto 0); 
			ROUND 			: in std_logic_vector (3 downto 0);
			enc				: in std_logic;
			-- OUTPUT
			valid_out 		: out std_logic;
			data_out			: out std_logic_vector (127 downto 0)
		);
	end component;
	
	component cbc is

		port(
			CLK, rst_n 		: in std_logic;
			
		-- INPUT
			--from interface
			data_in			: in std_logic_vector (127 downto 0);
			--from cipher
			cryptrounddata	: in std_logic_vector (31 downto 0);
			valid_in			: in std_logic;
			loading			: in std_logic;
			enc				: in std_logic;
		-- OUTPUT
			tocryptdata		: out std_logic_vector (31 downto 0);
			valid_out 		: out std_logic;
			data_out			: out std_logic_vector (127 downto 0)
		);
	end component;
	
	
	signal ROUND				: std_logic_vector (3 downto 0);
	signal keywords_valid 	: std_logic;
	signal keywords			: std_logic_vector (127 downto 0);
	signal cryptrounddata	: std_logic_vector (31 downto 0);
	signal cryptround_valid : std_logic;
	signal tocryptdata		: std_logic_vector (31 downto 0);
	signal loading				: std_logic;
	

begin

	KGEN 	: key_generator port map( CLK => CLK, rst_n => rst_n, 
									enc => enc,
									key => key, 
									key_len => key_lenght, ROUND => ROUND,
									valid_out => keywords_valid, data_out => keywords );
									
	DUNIT	: dataunit port map( CLK => CLK, rst_n => rst_n, 
									keywords => keywords, loading => loading,
									in0=>tocryptdata(31 downto 24), in1=>tocryptdata(23 downto 16), 
									in2=>tocryptdata(15 downto 8), in3=>tocryptdata(7 downto 0),
									key_lenght => key_lenght, enc => enc, ROUND => ROUND,
									key_valid => keywords_valid,
									data_out0 => cryptrounddata(31 downto 24) , data_out1 => cryptrounddata(23 downto 16), 
									data_out2 => cryptrounddata(15 downto 8), data_out3 => cryptrounddata(7 downto 0),
									valid_out => cryptround_valid );
									
	DL		: cbc port map( 	CLK => CLK, rst_n => rst_n, data_in => data, cryptrounddata =>cryptrounddata, valid_in => cryptround_valid,
									data_out => crypted_data, valid_out => valid_out, loading => loading,
									tocryptdata => tocryptdata, enc => enc);
 

end arc;

