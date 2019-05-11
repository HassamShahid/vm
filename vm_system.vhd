library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vm_system is
port(
		option: in std_logic_vector(1 downto 0);
		data1 : inout std_logic_vector(1 downto 0);
		data2 : inout std_logic_vector(1 downto 0);
		data3 : in std_logic_vector(1 downto 0);
		data4 : in std_logic_vector(3 downto 0);
		data5 : in std_logic;
		item1 : inout std_logic_vector(0 downto 0);
		item2 : inout std_logic_vector(0 downto 0);
		item3 : inout std_logic_vector(0 downto 0);
		item4 : inout std_logic_vector(0 downto 0);
		item5 : inout std_logic_vector(0 downto 0);
		item6 : inout std_logic_vector(0 downto 0);
		item7 : inout std_logic_vector(0 downto 0);
		item8 : inout std_logic_vector(0 downto 0);
		item9 : inout std_logic_vector(0 downto 0);
		item0 : inout std_logic_vector(0 downto 0);
		addr	: in std_logic_vector(4 downto 0);
		key 	: in std_logic;
		wren	: in std_logic;
		q		: out std_logic_vector(3 downto 0):="0000"
);
end entity;

architecture machine of vm_system is

		signal data 			 : std_logic_vector(3 downto 0);
		signal data_out 		 : std_logic_vector(3 downto 0);
		signal food_stockRAM  : std_logic_vector(3 downto 0);
		signal drink_stockRAM : std_logic_vector(3 downto 0);
		
		component vm
			port(
					moneyin		: inout std_logic_vector(1 downto 0);
					moneyout		: inout std_logic_vector(1 downto 0);
					choice		: in std_logic_vector(1 downto 0);
					choose		: in std_logic_vector(3 downto 0);
					clk			: in std_logic;
					reset			: in std_logic;
					food_stock  : out std_logic_vector(3 downto 0);
					drink_stock : out std_logic_vector(3 downto 0);
					drink1, drink2, drink3, drink4, drink5, food1, food2, food3, food4, food5 : inout std_logic_vector(0 downto 0)
			);
		end component;
		
		begin
		
		ram32x4_inst :
		entity work.ram32x4 
		port map(
					address => addr,
					clock	  => key,
					data    => data,
					wren    => wren,
					q       => data_out
		);
	
		with option select
		data <= drink_stockRAM when "00",
				  food_stockRAM when  "01",
				  "0000" when others;
		
		q <= data_out;
		
		vm_go : vm port map(data1, data2, data3, data4, key, data5, food_stockRAM, drink_stockRAM, item1, item2, item3, item4, item5, item6, item7, item8, item9, item0);
		
end architecture;