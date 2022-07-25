library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_reti_logiche is
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;
		i_start : in std_logic;
		i_data : in std_logic_vector (7 downto 0);
		o_address : out std_logic_vector (15 downto 0);
		o_done : out std_logic;
		o_en : out std_logic;
		o_we : out std_logic;
		o_data : out std_logic_vector (7 downto 0)
	);
end project_reti_logiche;

architecture behavioral of project is

	component datapath is
		port (

		);
	end component;

	component conv is
		port (
			i_clk : in std_logic;
			i_rst : in std_logic;
			i_u : in std_logic;
			o_p1 : out std_logic;
			o_p2 : out std_logic
		);
	end component;

	type s is (s0, s1, s2, s3, s4, s5, s6, s7);

	signal curr_state : s;
	signal next_state : s;
	signal conv_u : std_logic;
	signal conv_p1 : std_logic;
	signal conv_p2 : std_logic;
	signal output_data : std_logic_vector (15 downto 0);

	begin
		CONVOLUTOR: conv port map (
			i_clk,
			i_rst,
			conv_u,
			conv_p1,
			conv_p2
		);

		process (i_clk, i_rst)
		begin
			if i_rst = '1' then
				curr_state <= s0;
			elsif i_clk'event and i_clk = '1' then
				curr_state <= next_state;
			end if;
		end process;

		process (curr_state, i_start, o_done)
		begin
			next_state <= curr_state;
			-- TODO use i_start and o_done
			case curr_state is
				when s0 =>
					next_state <= s1;
				when s1 =>
					next_state <= s2;
				when s2 =>
					next_state <= s3;
				when s3 =>
					next_state <= s4;
				when s4 =>
					next_state <= s5;
				when s5 =>
					next_state <= s6;
				when s6 =>
					next_state <= s7;
				when s7 =>
					next_state <= s0;
			end case;
		end process;

		process (curr_state)
			case curr_state is
				when s0 =>
					conv_u <= i_data(7);
					output_data(15 downto 14) <= (conv_p1, conv_p2);
				when s1 =>
					conv_u <= i_data(6);
					output_data(13 downto 12) <= (conv_p1, conv_p2);
				when s2 =>
					conv_u <= i_data(5);
					output_data(11 downto 10) <= (conv_p1, conv_p2);
				when s3 =>
					conv_u <= i_data(4);
					output_data(9 downto 8) <= (conv_p1, conv_p2);
				when s4 =>
					conv_u <= i_data(3);
					output_data(7 downto 6) <= (conv_p1, conv_p2);
				when s5 =>
					conv_u <= i_data(2);
					output_data(5 downto 4) <= (conv_p1, conv_p2);
				when s6 =>
					conv_u <= i_data(1);
					output_data(3 downto 2) <= (conv_p1, conv_p2);
				when s7 =>
					conv_u <= i_data(0);
					output_data(1 downto 0) <= (conv_p1, conv_p2);
			end case;
		end process;

end behavioral;