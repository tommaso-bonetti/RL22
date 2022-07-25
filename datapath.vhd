library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;
		i_data : in std_logic_vector (7 downto 0);
		o_data : out std_logic_vector (7 downto 0);
		o_data_long : out std_logic_vector (15 downto 0);
		o_address : out std_logic_vector (15 downto 0);
		load_raddr : in std_logic;
		load_waddr : in std_logic;
		load_num : in std_logic;
		sel_out : in std_logic;
		rw : in std_logic;
	);
end datapath;

architecture behavioral of datapath is

	signal read_addr : std_logic_vector (15 downto 0);
	signal write_addr : std_logic_vector (15 downto 0);
	signal num_words : std_logic_vector (7 downto 0);
	signal mux_waddr : std_logic_vector (15 downto 0);
	signal sum_r : std_logic_vector (15 downto 0);
	signal ls : std_logic_vector (15 downto 0);
	signal sum_w : std_logic_vector (15 downto 0);
	signal sub : std_logic_vector (15 downto 0);

	begin
		sum_r <= read_addr + "0000000000000001";

		process (i_clk, i_rst)
		begin
			if i_rst = '1' then
				read_addr <= "000000000000000000";
			elsif i_clk'event and i_clk = '1' then
				if load_raddr = '1' then
					read_addr <= sum_r;
				end if;
			end if;
		end process;

		ls <= read_addr(14 downto 0) & "0";
		sum_w <= ls + "0000000000000001";

		with sel_out select
			mux_reg3 <=
					ls when '0',
					sum_w when '1',
					"XXXXXXXXXXXXXXXX" when others;

		process (i_clk, i_rst)
		begin
			if i_rst = '1' then
				write_addr <= "000000000000000000";
			elsif i_clk'event and i_clk = '1' then
				if load_waddr = '1' then
					write_addr <= mux_reg3;
				end if;
			end if;
		end process;

		with sel_out select
			o_data <=
					o_data_long(15 downto 8) when '0',
					o_data_long(7 downto 0) when '1',
					"XXXXXXXX" when others;

		with rw select
			o_address <=
					read_addr when '0',
					write_addr when '1',
					"XXXXXXXXXXXXXXXX" when others;

		process (i_clk, i_rst)
		begin
			if i_rst = '1' then
				num_words <= "000000000";
			elsif i_clk'event and i_clk = '1' then
				if load_num = '1' then
					num_words <= i_data;
				end if;
			end if;
		end process;

		sub <= ("00000000" & num_words) - read_addr;
		o_done <= '1' when sub = "0000000000000000" else '0';

end architecture behavioral;