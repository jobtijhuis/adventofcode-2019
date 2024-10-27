library ieee;
  context ieee.ieee_std_context;

package utils is

  function Log2Ceil(i : natural) return integer;

  function str_to_slv(str : string) return std_logic_vector;

  function Reverse(input : std_ulogic_vector; chunk_size : natural) return std_ulogic_vector;

end package;

package body utils is

  function Log2Ceil(i : natural) return integer is
    variable tmp : integer := i;
    variable ret : integer := 0;
  begin
      while tmp >= 1 loop
          ret  := ret + 1;
          tmp := tmp / 2;
      end loop;
      return ret;
  end function;

  function str_to_slv(str : string) return std_logic_vector is
    alias str_norm : string(str'length downto 1) is str;
    variable res_v : std_logic_vector(8 * str'length - 1 downto 0);
  begin
    for idx in str_norm'range loop
      res_v(8 * idx - 1 downto 8 * idx - 8) :=
        std_logic_vector(to_unsigned(character'pos(str_norm(idx)), 8));
    end loop;
    return res_v;
  end function;

  function Reverse(input : std_ulogic_vector; chunk_size : natural) return std_ulogic_vector is
    constant norm_vec   : std_ulogic_vector(input'length - 1 downto 0) := input;
    variable result     : norm_vec'subtype;
    constant NUM_CHUNKS : natural := input'length / chunk_size;
  begin

    for i in 0 to NUM_CHUNKS - 1 loop
      result(norm_vec'low + (i+1)*chunk_size - 1 downto norm_vec'low + i*chunk_size)
        := input(norm_vec'high - i*chunk_size downto norm_vec'high - (i+1)*chunk_size + 1);
    end loop;
    return result;
  end function;

end package body;