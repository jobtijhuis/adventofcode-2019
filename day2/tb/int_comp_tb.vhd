library ieee;
  context ieee.ieee_std_context;

library osvvm;
  context osvvm.OsvvmContext;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_types_pkg.all;
  use vunit_lib.run_pkg.all;

entity int_comp_tb is
  generic (
    CLOCK_PERIOD : time    := 10 ns;
    TEST_TIMEOUT : time    := 1 us;
    RUNNER_CFG   : string  := RUNNER_CFG_DEFAULT;
  );
end entity;

architecture sim of int_comp_tb is

  signal clock    : std_ulogic := '0';
  signal n_areset : std_ulogic := '0';

  -- signal uart_receiver_rec : UartRecType;

begin

  CreateClock(clock, CLOCK_PERIOD);
  CreateReset(n_areset, '0', clock, CLOCK_PERIOD);

  process
  begin
    test_runner_setup(runner, RUNNER_CFG);

    SetAlertStopCount(ERROR, 5);

    Check(GetAlertCount = 0);
    ReportAlerts;
    test_runner_cleanup(runner);
  end process;

  test_runner_watchdog(runner, TEST_TIMEOUT);

end architecture;