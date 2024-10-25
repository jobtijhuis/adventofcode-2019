library ieee;
  context ieee.ieee_std_context;

entity int_comp is
  generic(
    DATA_WIDTH : natural := 8;
    ADDR_WIDTH : natural := 8
  );
  port (
    clock    : in std_ulogic;
    n_areset : in std_ulogic;

    a_write_enable  : In  std_logic ;
    a_address       : In  std_logic_vector(ADDR_WIDTH-1 downto 0) ;
    DataInA     : In  std_logic_vector(DATA_WIDTH-1 downto 0) ;
    DataOutA    : Out std_logic_vector(DATA_WIDTH-1 downto 0) ;

    WriteB      : In  std_logic ;
    AddrB       : In  std_logic_vector(ADDR_WIDTH-1 downto 0) ;
    DataInB     : In  std_logic_vector(DATA_WIDTH-1 downto 0) ;
    DataOutB    : Out std_logic_vector(DATA_WIDTH-1 downto 0)

  );
end entity;

architecture syn of int_comp is

begin



end architecture;