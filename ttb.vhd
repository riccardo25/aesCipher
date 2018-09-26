--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:48:28 09/23/2018
-- Design Name:   
-- Module Name:   D:/Repository/XILINX/aescomplete/ttb.vhd
-- Project Name:  aescomplete
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cipher
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ttb IS
END ttb;
 
ARCHITECTURE behavior OF ttb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cipher
    PORT(
         CLK : IN  std_logic;
         rst_n : IN  std_logic;
         --data : IN  std_logic_vector(127 downto 0);
         key_lenght : IN  std_logic_vector(1 downto 0);
         enc : IN  std_logic;
         valid_out : OUT  std_logic;
         crypted_data : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal data : std_logic_vector(127 downto 0) := (others => '0');
   signal key_lenght : std_logic_vector(1 downto 0) := (others => '0');
   signal enc : std_logic := '0';

 	--Outputs
   signal valid_out : std_logic;
   signal crypted_data : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cipher PORT MAP (
          CLK => CLK,
          rst_n => rst_n,
          --data => data,
          key_lenght => key_lenght,
          enc => enc,
          valid_out => valid_out,
          crypted_data => crypted_data
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		rst_n <= '1';
		--data <= X"3243f6a8885a308d313198a2e0370734";
		key_lenght <= "10";
		enc <='0';

      wait;
   end process;

END;
