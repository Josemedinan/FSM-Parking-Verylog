# Legacy P2 timing analysis: Moore FSM using SN74HC logic

This section retains the original focus of the GitHub repository before the Basys 3 implementation. The original circuit is `circuito/barrera_codigo(1).circ` (Logisim Evolution); the path examined was:

`FF(Q1) -> NOT(Q1) -> AND -> OR -> OR -> FF(D1)`.

The three-input OR in the Logisim design is represented by two cascaded two-input SN74HC32 OR gates on the analyzed branch (conservative example).

| Component | Part | Reference delay |
|:--|:--|:--|
| D flip-flop | SN74HC74N | CLK-to-Q max 44 ns; setup 25 ns; hold 0 ns |
| NOT | SN74HC04N | Propagation max 24 ns |
| AND2 | SN74HC08N | Propagation max 25 ns |
| OR2 | SN74HC32N | Propagation max 25 ns per gate |

Reference conditions: VCC=4.5 V; ambient range -40 to +85 C. The exact loads, wiring parasitics and clock skew are not measured.

## Setup and estimated path frequency

`Tclock >= tCQ,max + tNOT,max + tAND,max + 2*tOR,max + tsetup`

`Tclock >= 44 + 24 + 25 + 2*25 + 25 = 168 ns`

`Fmax,path = 1 / (168 ns) = 5.952 MHz`.

**This is not a measured FPGA Fmax, not a complete-chip critical-path report, and not a characterization of the combined Mealy/Moore system.**

## Hold

` tCQ,min + tCD,min >= thold + tskew `.

For zero skew and a 0 ns hold requirement on the SN74HC74, the path would satisfy the inequality if physical minimum delays are nonnegative. There is insufficient guaranteed minimum-delay information to claim a quantified positive hold margin.

## Preserved original repository material

- [Circuit](../circuito/barrera_codigo%281%29.circ)
- [Gate-delay table](../analisis/retardos.csv)
- [Moore next-state logic image](../evidencias/logica_moore.png)
- [Moore state registers](../evidencias/registros_moore.png)

## Manufacturer datasheets

- [SN74HC74](https://www.ti.com/lit/gpn/sn74hc74)
- [SN74HC04](https://www.ti.com/lit/ds/symlink/sn74hc04.pdf)
- [SN74HC08](https://www.ti.com/lit/gpn/sn74hc08)
- [SN74HC32](https://www.ti.com/lit/gpn/sn74hc32)
