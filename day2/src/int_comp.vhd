library ieee;
  context ieee.ieee_std_context;

entity int_comp is
  generic(
    ADDR_WIDTH : natural;
    DATA_WIDTH : natural;
    START_ADDR : natural := 0
  );
  port (
    clock    : in std_ulogic;
    n_areset : in std_ulogic;

    start    : in std_ulogic;

    a_wr_e     : out std_logic;
    a_addr     : out u_unsigned(ADDR_WIDTH-1 downto 0);
    a_data_out : out u_unsigned(DATA_WIDTH-1 downto 0);
    a_data_in  : in  u_unsigned(DATA_WIDTH-1 downto 0);

    b_wr_e     : out std_logic;
    b_addr     : out u_unsigned(ADDR_WIDTH-1 downto 0);
    b_data_out : out u_unsigned(DATA_WIDTH-1 downto 0);
    b_data_in  : in  u_unsigned(DATA_WIDTH-1 downto 0);

    halt_out  : out std_logic;
    error_out : out std_logic

  );
end entity;

architecture syn of int_comp is

  ----- Different CPU stages:
  -----I-Dec---Load---Load2---Comp
  -- A  R-I    RL-D2  R-D2    W-O
  -- B  RL-D1  R-D1   RL-O

  type cpu_stage is (Reset, InstDec, Load, Load2, Comp, Halt, Error);

  signal stage      : cpu_stage;
  signal next_stage : cpu_stage;


  signal instr_addr      : u_unsigned(ADDR_WIDTH - 1 downto 0);
  signal next_instr_addr : u_unsigned(ADDR_WIDTH - 1 downto 0);

  signal opcode : u_unsigned(DATA_WIDTH - 1 downto 0);
  signal op1    : u_unsigned(DATA_WIDTH - 1 downto 0);
  signal next_opcode : u_unsigned(DATA_WIDTH - 1 downto 0);
  signal next_op1    : u_unsigned(DATA_WIDTH - 1 downto 0);
  -- signal op2 : unsigned(DATA_WIDTH - 1 downto 0);

  constant O_ADD  : u_unsigned(DATA_WIDTH - 1 downto 0) := to_unsigned(1,  DATA_WIDTH);
  constant O_MULT : u_unsigned(DATA_WIDTH - 1 downto 0) := to_unsigned(2,  DATA_WIDTH);
  constant O_HALT : u_unsigned(DATA_WIDTH - 1 downto 0) := to_unsigned(99, DATA_WIDTH);

begin

  process (clock, n_areset)
  begin
    if n_areset = '0' then
      stage      <= Reset;
      instr_addr <= (others => '0');
      opcode     <= (others => '0');
      op1        <= (others => '0');
    elsif rising_edge(clock) then
      stage      <= next_stage;
      instr_addr <= next_instr_addr;
      opcode     <= next_opcode;
      op1        <= next_op1;
    end if;
  end process;

  process (all)
  begin
    -- Defaults to prevent latches
    next_op1    <= (others => '0');
    a_wr_e      <= '0';
    a_addr      <= (others => '0');
    a_data_out  <= (others => '0');
    b_wr_e      <= '0';
    b_addr      <= (others => '0');
    b_data_out  <= (others => '0');
    halt_out    <= '0';
    error_out   <= '0';

    -- Stay in stage unless otherwise specified
    next_stage  <= stage;
    next_opcode <= opcode;

    case stage is
      when Reset =>
        next_stage <= Halt;
      when InstDec =>
        a_addr <= instr_addr;     -- start read R-I
        b_addr <= instr_addr + 1; -- start read RL-D1
        next_stage <= Load;
      when Load =>
        next_opcode <= a_data_in;      -- read R-I
        a_addr      <= instr_addr + 2; -- start read RL-D2
        b_addr      <= b_data_in;      -- start read R-D1
        next_stage  <= Load2;
      when Load2 =>
        next_op1    <= b_data_in;      -- read R-D1
        a_addr      <= a_data_in;      -- start read R-D2
        b_addr      <= instr_addr + 3; -- start read RL-O
        next_stage  <= Comp;
      when Comp =>
        if opcode = O_HALT then
          next_stage <= Halt;
          next_instr_addr <= instr_addr + 1;
        else
          a_wr_e     <= '1';
          a_addr     <= b_data_in; -- W-O
          if opcode = O_ADD then
            a_data_out <= op1 + a_data_in; -- D1 + D2
            next_stage <= InstDec;
          elsif opcode = O_MULT then
            a_data_out <= resize(op1 * a_data_in, a_data_out'length); -- D1 * D2
            next_stage <= InstDec;
          else
            next_stage <= Error;
          end if;
          next_instr_addr <= instr_addr + 4;
        end if;

      when Halt =>
        halt_out <= '1';
        if start then
          next_instr_addr <= to_unsigned(START_ADDR, instr_addr'length);
          next_stage      <= InstDec;
        end if;
      when Error =>
        error_out <= '1';
    end case;
  end process;



end architecture;