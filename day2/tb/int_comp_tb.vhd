library ieee;
  context ieee.ieee_std_context;

library osvvm;
  context osvvm.OsvvmContext;

library osvvm_dpram;
  context osvvm_dpram.DpRamContext;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_types_pkg.all;
  use vunit_lib.run_pkg.all;

entity int_comp_tb is
  generic (
    CLOCK_PERIOD : time    := 10 ns;
    TEST_TIMEOUT : time    := 1 ms;
    RUNNER_CFG   : string  := RUNNER_CFG_DEFAULT;
    ADDR_WIDTH   : natural := 32;
    DATA_WIDTH   : natural := 32
  );
end entity;

architecture sim of int_comp_tb is

  signal clock    : std_ulogic := '0';
  signal n_areset : std_ulogic := '0';

  -- signal uart_receiver_rec : UartRecType;

  signal main_memory : MemoryIdType;

  signal start : std_ulogic := '0';

  signal a_wr_e     :  std_ulogic;
  signal a_addr     :  u_unsigned(ADDR_WIDTH-1 downto 0);
  signal a_data_in  :  u_unsigned(DATA_WIDTH-1 downto 0);
  signal a_data_out :  u_unsigned(DATA_WIDTH-1 downto 0);
  signal b_wr_e     :  std_ulogic;
  signal b_addr     :  u_unsigned(ADDR_WIDTH-1 downto 0);
  signal b_data_in  :  u_unsigned(DATA_WIDTH-1 downto 0);
  signal b_data_out :  u_unsigned(DATA_WIDTH-1 downto 0);

  signal halt_out  : std_ulogic;
  signal error_out : std_ulogic;

  function to_integer_vector(input : slv_vector; signed_values : boolean := FALSE) return integer_vector is
    variable result : integer_vector(input'range);
  begin
    for i in input'range loop
      if signed_values then
        result(i) := to_integer(signed(input(i)));
      else
        result(i) := to_integer(unsigned(input(i)));
      end if;
    end loop;
    return result;
  end function;

  function Stringify(
    data       : std_ulogic_vector;
    separator  : string := "";
    part_width : natural := DATA_WIDTH
  ) return string is
  begin

    return to_string( to_integer(unsigned(data(data'high downto data'high - part_width + 1))) )& separator &
           Stringify( data(data'high - part_width downto data'low), separator);

  end function;

  function Stringify(
    data       : slv_vector;
    separator  : string := ""
  ) return string is
  begin
    if data'length > 1 then
      return to_string(data(data'low))& separator & Stringify(data(data'low + 1 to data'high), separator);
    else
      return to_string(data(data'low))& separator;
    end if;
  end function;

  function Stringify(
    data       : integer_vector;
    separator  : string := ""
  ) return string is
  begin
    if data'length > 1 then
      return to_string(data(data'low))& separator & Stringify(data(data'low + 1 to data'high), separator);
    else
      return to_string(data(data'low))& separator;
    end if;
  end function;


begin

  CreateClock(clock, CLOCK_PERIOD);
  CreateReset(n_areset, '0', clock, CLOCK_PERIOD);

  int_comp_inst: entity work.int_comp
    generic map(
      ADDR_WIDTH => ADDR_WIDTH,
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      clock      => clock,
      n_areset   => n_areset,
      start      => start,
      a_wr_e     => a_wr_e,
      a_addr     => a_addr,
      a_data_out => a_data_in,
      a_data_in  => a_data_out,
      b_wr_e     => b_wr_e,
      b_addr     => b_addr,
      b_data_out => b_data_in,
      b_data_in  => b_data_out,

      halt_out  => halt_out,
      error_out => error_out
    );

  -- a_wr_e <= '0';
  -- a_data_in <= (others => '0');

  -- b_wr_e    <= '0';
  -- b_addr    <= (others => '0');
  -- b_data_in <= (others => '0');

  process
    constant example_0     : integer_vector(0 to 11) := (1,9,10,3, 2,3,11,0, 99,30,40,50);
    constant res_example_0 : integer_vector(0 to 11) := (3500,9,10,70, 2,3,11,0, 99,30,40,50);
    constant example_1     : integer_vector(0 to 4) := (1,0,0,0,99);
    constant res_example_1 : integer_vector(0 to 4) := (2,0,0,0,99);
    constant example_2     : integer_vector(0 to 4) := (2,3,0,3,99);
    constant res_example_2 : integer_vector(0 to 4) := (2,3,0,6,99);
    constant example_3     : integer_vector(0 to 5) := (2,4,4,5,99,0);
    constant res_example_3 : integer_vector(0 to 5) := (2,4,4,5,99,9801);
    constant example_4     : integer_vector(0 to 8) := (1,1,1,4,99,5,6,0,99);
    constant res_example_4 : integer_vector(0 to 8) := (30,1,1,4,2,5,6,0,99);

    constant main_program_part1 : integer_vector := (1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,19,9,23,1,5,23,27,1,27,9,31,1,6,31,35,2,35,9,39,1,39,6,43,2,9,43,47,1,47,6,51,2,51,9,55,1,5,55,59,2,59,6,63,1,9,63,67,1,67,10,71,1,71,13,75,2,13,75,79,1,6,79,83,2,9,83,87,1,87,6,91,2,10,91,95,2,13,95,99,1,9,99,103,1,5,103,107,2,9,107,111,1,111,5,115,1,115,5,119,1,10,119,123,1,13,123,127,1,2,127,131,1,131,13,0,99,2,14,0,0);


    procedure CheckMemory(data : integer_vector) is
    begin

      for i in data'range loop
        AffirmIfEqual(
          Received => to_integer(unsigned(MemRead(main_memory, std_logic_vector(to_unsigned(i, DATA_WIDTH))))),
          Expected => data(i),
          Message  => "CheckMemory"
        );
      end loop;

    end procedure;

    procedure RunExample(start_data : integer_vector; end_data : integer_vector; print_int : boolean := FALSE) is
      constant norm_data : integer_vector(0 to start_data'length - 1) := start_data;
      variable data_out : slv_vector(0 to start_data'length - 1)(DATA_WIDTH - 1 downto 0);
      variable command_base : natural;
    begin

      for i in norm_data'range loop
        MemWrite(main_memory,
          Addr => std_logic_vector(to_unsigned(i, DATA_WIDTH)),
          Data => std_logic_vector(to_unsigned(norm_data(i), DATA_WIDTH))
        );
      end loop;

      start <= '1';
      WaitForClock(clock);
      start <= '0';

      loop
        wait until (a_wr_e = '1' or halt_out = '1') and rising_edge(clock);
        exit when halt_out = '1';
        for i in data_out'range loop
          MemRead(main_memory, std_logic_vector(to_unsigned(i, DATA_WIDTH)), data_out(i));
          command_base := i - i mod 4;
          if (i mod 4 = 3 or i = data_out'high) and print_int then
            Log( Stringify(to_integer_vector(data_out(command_base to minimum(command_base + 3, data_out'high))), ","));
          end if;
        end loop;
      end loop;

      CheckMemory(end_data);
    end procedure;

    procedure RunProgram(start_data : integer_vector; noun : integer; verb : integer; print_mem : boolean := FALSE) is
      constant norm_data    : integer_vector(0 to start_data'length - 1) := start_data;
      variable data_out     : slv_vector(0 to start_data'length - 1)(DATA_WIDTH - 1 downto 0);
      variable command_base : natural;
    begin

      for i in norm_data'range loop
        MemWrite(main_memory,
          Addr => std_logic_vector(to_unsigned(i, DATA_WIDTH)),
          Data => std_logic_vector(to_unsigned(norm_data(i), DATA_WIDTH))
        );
      end loop;

      MemWrite(main_memory,
        Addr => std_logic_vector(to_unsigned(1, DATA_WIDTH)),
        Data => std_logic_vector(to_unsigned(noun, DATA_WIDTH))
      );
      MemWrite(main_memory,
        Addr => std_logic_vector(to_unsigned(2, DATA_WIDTH)),
        Data => std_logic_vector(to_unsigned(verb, DATA_WIDTH))
      );

      start <= '1';
      WaitForClock(clock);
      start <= '0';

      wait until halt_out = '1' and rising_edge(clock);

      if print_mem then
        for i in data_out'range loop
          MemRead(main_memory, std_logic_vector(to_unsigned(i, DATA_WIDTH)), data_out(i));
          command_base := i - i mod 4;
          if (i mod 4 = 3 or i = data_out'high) then
            Log( Stringify(to_integer_vector(data_out(command_base to minimum(command_base + 3, data_out'high))), ","));
          end if;
        end loop;
      end if;

    end procedure;

    variable noun,verb : integer;

  begin
    test_runner_setup(runner, RUNNER_CFG);
    wait for 0 ns;

    main_memory <= NewID("main_memory",
      AddrWidth => ADDR_WIDTH,
      DataWidth => DATA_WIDTH,
      Search    => NAME
    );
    wait for 0 ns;

    wait until n_areset = '1' and rising_edge(clock);

    RunExample(example_0, res_example_0);
    RunExample(example_1, res_example_1);
    RunExample(example_2, res_example_2);
    RunExample(example_3, res_example_3);
    RunExample(example_4, res_example_4);

    Log("Starting program part 1");
    RunProgram(main_program_part1, 12, 2);
    AffirmIfEqual(
      Received => to_integer(unsigned(MemRead(main_memory, std_logic_vector(to_unsigned(0, DATA_WIDTH))))),
      Expected => 3409710,
      Message  => "Part 1"
    );

    noun := 79;
    -- verb := 2;
    for i in 0 to 99 loop
      verb := i;
      RunProgram(main_program_part1, noun, verb);
      Log("noun: "&to_string(noun)&" verb: "&to_string(verb)&" output: "&
        to_string(to_integer(unsigned(MemRead(main_memory, std_logic_vector(to_unsigned(0, DATA_WIDTH))))))
      );
    end loop;

    WaitForClock(clock);

    SetAlertStopCount(ERROR, 5);

    Check(GetAlertCount = 0);
    ReportAlerts;
    test_runner_cleanup(runner);
  end process;

  dpram_inst: entity osvvm_dpram.DpRam
   generic map(
      ADDR_WIDTH  => ADDR_WIDTH,
      DATA_WIDTH  => DATA_WIDTH,
      MEMORY_NAME => "main_memory"
  )
   port map(
      ClkA               => clock,
      WriteA             => a_wr_e,
      AddrA              => std_ulogic_vector(a_addr),
      DataInA            => std_ulogic_vector(a_data_in),
      unsigned(DataOutA) => a_data_out,
      ClkB               => clock,
      WriteB             => b_wr_e,
      AddrB              => std_ulogic_vector(b_addr),
      DataInB            => std_ulogic_vector(b_data_in),
      unsigned(DataOutB) => b_data_out
  );

  test_runner_watchdog(runner, TEST_TIMEOUT);

end architecture;