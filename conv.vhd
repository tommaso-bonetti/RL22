library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conv is
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;
		i_u : in std_logic;
		o_p1 : out std_logic;
		o_p2 : out std_logic
	);
end fsm;

architecture behavioral of conv is

	type s is (s0, s1, s2, s3);

	signal curr_state : s;
	signal next_state : s;

	begin
		process (i_clk, i_rst)
		begin
			if i_rst = '1' then
				curr_state <= s0;
			elsif i_clk'event and i_clk = '1' then
				curr_state <= next_state;
			end if;
		end process;

		process (curr_state)
		begin
			next_state <= curr_state;

			case curr_state is
				when s0 =>
					if i_u = '0' then
						o_p1 <= '0';
						o_p2 <= '0';
						next_state <= s0;
					elsif i_u = '1' then
						o_p1 <= '1';
						o_p2 <= '1';
						next_state <= s2;
					end if;
				when s1 =>
					if i_u = '0' then
						o_p1 <= '1';
						o_p2 <= '1';
						next_state <= s0;
					elsif i_u = '1' then
						o_p1 <= '0';
						o_p2 <= '0';
						next_state <= s2;
					end if;
				when s2 =>
					if i_u = '0' then
						o_p1 <= '0';
						o_p2 <= '1';
						next_state <= s1;
					elsif i_u = '1' then
						o_p1 <= '1';
						o_p2 <= '0';
						next_state <= s3;
					end if;
				when s3 =>
					if i_u = '0' then
						o_p1 <= '1';
						o_p2 <= '0';
						next_state <= s1;
					elsif i_u = '1' then
						o_p1 <= '0';
						o_p2 <= '1';
						next_state <= s3;
					end if;
			end case;
		end process;

end architecture behavioral;