# Hardware description source

This directory contains the original Mealy/Moore core migrated from the Logisim design and the later Basys 3 board adapter.

## Files

| File | Role |
|:--|:--|
| `src/mealy.sv` | A -> C -> B code sequence |
| `src/moore.sv` | Parking barrier states |
| `src/top.sv` | Core integration; new `CE` port controls state advances |
| `src/top_basys3.sv` | Basys 3 hardware top; instantiates input conditioning and core |
| `src/debounce_onepulse.sv` | Synchronizer and 20 ms debounce with rising-edge event |
| `src/tick_enable.sv` | 4 Hz clock-enable from 100 MHz input (no second clock) |
| `src/reset_sync.sv` | Asynchronous assertion, synchronous release |
| `sim/testbench.sv` | Base core tests |
| `sim/testbench_basys3.sv` | Board integration tests with simulation-reduced parameters |
| `constraints/basys3.xdc` | Clock, switches, button and LEDs |

Synthesis top: `top_basys3` | Simulation top: `testbench_basys3` | Part: `xc7a35tcpg236-1`.

For the actual logic-gate equations, see the original source files and [legacy Logisim analysis](../docs/ANALISIS_TEMPORAL_SN74HC.md). For how to run and document Vivado, see [the setup guide](../docs/GUIA_VIVADO_GITHUB.md).
