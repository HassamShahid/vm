library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vm is
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
end entity;

architecture bhv of vm is 
type state_type is(
		idle, 
		money_check,
		grab, 
		change, Food, Drink,
		stock
);

signal next_state: state_type;
signal food_count: std_logic_vector(3 downto 0):="1111";
signal drink_count: std_logic_vector(3 downto 0):="1111";
signal rst: std_logic;

begin
process (clk, rst)
	begin
	if (rst = '1') then
		next_state 	<= idle;
		moneyin 	<= "00";
		moneyout	<= "00";
		drink1 	<= "0"; 
		drink2  	<= "0"; 
		drink3  	<= "0"; 
		drink4  	<= "0"; 
		drink5  	<= "0"; 
		food1  	<= "0"; 
		food2 	<= "0";
		food3 	<= "0";
		food4 	<= "0";
		food5 	<= "0";

	elsif rising_edge(clk) then 
		case next_state is
			when idle =>
				rst <= '1';
				if (moneyin = "00") then
					next_state <= idle;
				else 
					next_state <= money_check;
				end if;

			when money_check =>
				if (moneyin = "10" or moneyin = "11") then
					next_state <= grab;
				else 
					next_state <= money_check;
				end if;

			when grab =>
			  case choice is
				when "00" =>
					next_state <= Drink;
				when "01" =>
					next_state <= Food;
				when others =>
					next_state <= grab;
				end case;

			when Drink =>
				case choose is
					when "0000" => 
						drink1 <= "1";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when "0001" => 
						drink1 <= "0";
						drink2 <= "1";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when "0010" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "1";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when "0011" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "1";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when others => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "1";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";
				end case;
				next_state <= change;

			when Food =>
				case choose is
					when "0100" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "1";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when "0101" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "1";
						food3  <= "0";
						food4  <= "0";
						food5  <= "0";

					when "0110" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "1";
						food4  <= "0";
						food5  <= "0";

					when "0111" => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "1";
						food5  <= "0";

					when others => 
						drink1 <= "0";
						drink2 <= "0";
						drink3 <= "0";
						drink4 <= "0";
						drink5 <= "0";
						food1  <= "0";
						food2  <= "0";
						food3  <= "0";
						food4  <= "0";
						food5  <= "1";
				end case;
				next_state <= change;

			when change =>
				if (moneyin = "11") then
					moneyout <= "01";
				else 
					moneyout <= "00";
				end if;
				next_state <= stock;
				
			when stock =>
				food_stock <= food_count - ("000" & (food1 + food2 + food3 + food4 + food5));
				drink_stock <= drink_count - ("000" & (drink1 + drink2 + drink3 + drink4 + drink5));
				rst <= '1';
				next_state <= idle;
				
		end case;
	end if;
end process;
end architecture;