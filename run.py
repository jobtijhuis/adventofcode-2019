import vunit
from pathlib import Path

vu = vunit.VUnit.from_argv(vhdl_standard="2019")

ROOT_DIR = Path(__file__).parent

vu.add_vhdl_builtins()

DAY2_DIR = ROOT_DIR / "day2"

day2 = vu.add_library("day2")
day2.add_source_files([
    DAY2_DIR / "src" / "*.vhd",
    DAY2_DIR / "tb" / "*.vhd",
])

OPEN_LOGIC_DIR = ROOT_DIR / "libraries" / "open_logic"
open_logic = vu.add_library("olo")
open_logic.add_source_files([
    OPEN_LOGIC_DIR / "src" / "base" / "vhdl" / "*.vhd",
    OPEN_LOGIC_DIR / "src" / "axi" / "vhdl" / "*.vhd",
    OPEN_LOGIC_DIR / "src" / "intf" / "vhdl" / "*.vhd",
])

OSVVM_DIR = Path(__file__).parent / "libraries" / "osvvm"
osvvm = vu.add_library("osvvm")
osvvm.add_source_files([
    # osvvm.pro
    OSVVM_DIR / "IfElsePkg.vhd",
    OSVVM_DIR / "OsvvmScriptSettingsPkg.vhd",
    OSVVM_DIR / "OsvvmSettingsPkg.vhd",
    OSVVM_DIR / "TextUtilPkg.vhd",
    OSVVM_DIR / "ResolutionPkg.vhd",
    OSVVM_DIR / "NamePkg.vhd",
    OSVVM_DIR / "OsvvmGlobalPkg.vhd",
    OSVVM_DIR / "VendorCovApiPkg_Aldec.vhd",
    # OSVVM_DIR / "VendorCovApiPkg.vhd",
    OSVVM_DIR / "LanguageSupport2019Pkg.vhd",
    OSVVM_DIR / "TranscriptPkg.vhd",
    OSVVM_DIR / "AlertLogPkg.vhd",
    OSVVM_DIR / "TbUtilPkg.vhd",
    OSVVM_DIR / "NameStorePkg.vhd",
    OSVVM_DIR / "MessageListPkg.vhd",
    OSVVM_DIR / "SortListPkg_int.vhd",
    OSVVM_DIR / "RandomBasePkg.vhd",
    OSVVM_DIR / "RandomPkg.vhd",
    OSVVM_DIR / "RandomProcedurePkg.vhd",
    OSVVM_DIR / "CoveragePkg.vhd",
    OSVVM_DIR / "DelayCoveragePkg.vhd",
    OSVVM_DIR / "ClockResetPkg.vhd",
    OSVVM_DIR / "ResizePkg.vhd",
    OSVVM_DIR / "ScoreboardGenericPkg.vhd",
    OSVVM_DIR / "ScoreboardPkg_slv.vhd",
    OSVVM_DIR / "ScoreboardPkg_int.vhd",
    OSVVM_DIR / "ScoreboardPkg_signed.vhd",
    OSVVM_DIR / "ScoreboardPkg_unsigned.vhd",
    OSVVM_DIR / "ScoreboardPkg_IntV.vhd",
    OSVVM_DIR / "MemorySupportPkg.vhd",
    OSVVM_DIR / "MemoryGenericPkg.vhd",
    OSVVM_DIR / "MemoryPkg.vhd",
    OSVVM_DIR / "ReportPkg.vhd",
    OSVVM_DIR / "OsvvmTypesPkg.vhd",
    OSVVM_DIR / "OsvvmScriptSettingsPkg_default.vhd",
    OSVVM_DIR / "OsvvmSettingsPkg_default.vhd",
    OSVVM_DIR / "RandomPkg2019.vhd",
    OSVVM_DIR / "OsvvmContext.vhd",
])

OSVVM_DPRAM_DIR = Path(__file__).parent / "libraries" / "osvvm_common" / "src"
osvvm_common = vu.add_library("osvvm_common")
osvvm_common.add_source_files([
    # src/Common.pro
    OSVVM_DPRAM_DIR / "ModelParametersPtPkg.vhd",
    OSVVM_DPRAM_DIR / "ModelParametersSingletonPkg.vhd",
    OSVVM_DPRAM_DIR / "FifoFillPkg_slv.vhd",
    OSVVM_DPRAM_DIR / "StreamTransactionPkg.vhd",
    OSVVM_DPRAM_DIR / "StreamTransactionArrayPkg.vhd",
    OSVVM_DPRAM_DIR / "AddressBusTransactionPkg.vhd",
    OSVVM_DPRAM_DIR / "AddressBusTransactionArrayPkg.vhd",
    OSVVM_DPRAM_DIR / "AddressBusResponderTransactionPkg.vhd",
    OSVVM_DPRAM_DIR / "AddressBusResponderTransactionArrayPkg.vhd",
    OSVVM_DPRAM_DIR / "AddressBusVersionCompatibilityPkg.vhd",
    OSVVM_DPRAM_DIR / "InterruptGlobalSignalPkg.vhd",
    OSVVM_DPRAM_DIR / "InterruptHandler.vhd",
    OSVVM_DPRAM_DIR / "InterruptHandlerComponentPkg.vhd",
    OSVVM_DPRAM_DIR / "InterruptGeneratorBit.vhd",
    OSVVM_DPRAM_DIR / "InterruptGeneratorBitVti.vhd",
    OSVVM_DPRAM_DIR / "InterruptGeneratorComponentPkg.vhd",
    OSVVM_DPRAM_DIR / "OsvvmCommonContext.vhd",
])

OSVVM_DPRAM_DIR = Path(__file__).parent / "libraries" / "osvvm_dpram" / "src"
osvvm_dpram = vu.add_library("osvvm_dpram")
osvvm_dpram.add_source_files([
    # src/Common.pro
    OSVVM_DPRAM_DIR / "DpRam_Singleton.vhd",
    OSVVM_DPRAM_DIR / "DpRamController_Blocking.vhd",
    OSVVM_DPRAM_DIR / "DpRamComponentPkg.vhd",
    OSVVM_DPRAM_DIR / "DpRamContext.vhd",
])

# OSVVM_AXI4_DIR = Path(__file__).parent / "libraries" / "osvvm_axi4"
# osvvm_axi4 = vu.add_library("osvvm_axi4")
# osvvm_axi4.add_source_files([
#     # common/common.pro
#     OSVVM_AXI4_DIR / "common/src/Axi4InterfaceCommonPkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4LiteInterfacePkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4InterfacePkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4CommonPkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4ModelPkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4OptionsPkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4OptionsArrayPkg.vhd",
#     OSVVM_AXI4_DIR / "common/src/Axi4VersionCompatibilityPkg.vhd",
#     # Axi4Lite/Axi4Lite.pro
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteComponentPkg.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteContext.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteManager.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteMonitor_dummy.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteSubordinate.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LiteMemory.vhd",
#     OSVVM_AXI4_DIR / "Axi4Lite/src/Axi4LitePassThru.vhd",

#     # AxiStream/src/build.pro
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamOptionsPkg.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamOptionsArrayPkg.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamTbPkg.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamTransmitter.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamTransmitterVti.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamReceiver.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamReceiverVti.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamComponentPkg.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamContext.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamGenericSignalsPkg.vhd",
#     OSVVM_AXI4_DIR / "AxiStream/src/AxiStreamSignalsPkg_32.vhd",

#     # Axi4/src/build.pro
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4ComponentPkg.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4ComponentVtiPkg.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4Context.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4Manager.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4ManagerVti.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4Monitor_dummy.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4Subordinate.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4SubordinateVti.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4Memory.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4MemoryVti.vhd",
#     OSVVM_AXI4_DIR / "Axi4/src/Axi4PassThru.vhd",
# ])

# OSVVM_UART_DIR = Path(__file__).parent / "libraries" / "osvvm_uart" / "src"
# osvvm_uart = vu.add_library("osvvm_uart")
# osvvm_uart.add_source_files([
#     # UART.pro
#     OSVVM_UART_DIR / "UartTbPkg.vhd",
#     OSVVM_UART_DIR / "ScoreboardPkg_Uart.vhd",
#     OSVVM_UART_DIR / "UartTxComponentPkg.vhd",
#     OSVVM_UART_DIR / "UartRxComponentPkg.vhd",
#     OSVVM_UART_DIR / "UartContext.vhd",
#     OSVVM_UART_DIR / "UartTx.vhd",
#     OSVVM_UART_DIR / "UartRx.vhd",
# ])

vu.add_compile_option("ghdl.a_flags", ["--warn-no-hide"]) # type: ignore
vu.set_compile_option("nvc.a_flags",["--relaxed"])

vu.set_compile_option("activehdl.vcom_flags", ["-relax","-dbg"])

# for file in vu.get_compile_order():
#     print(file.name)

vu.main()