# Release checklist

- [x] Mealy/Moore source modules integrated with `top_basys3`.
- [x] Basys 3 pin constraints documented.
- [x] Vivado 2018.1 synthesis completed (shown in evidence).
- [x] Vivado 2018.1 implementation completed (shown in evidence).
- [x] Timing WNS +5.669 ns, WHS +0.122 ns, no failing endpoints (captured).
- [x] Bitstream generation completed.
- [x] `top_basys3.bit` programmed via Digilent FPGA Utility (2.113 s).
- [ ] Capture **full** XSim testbench PASS result (`run all`) and save screenshot if needed.
- [ ] Capture **updated** `top_basys3` Report Utilization (LUT/FF/IO counts).
- [ ] Capture a video or successive board photos showing A -> C -> B and SW3 hold/close sequence.
- [ ] Merge this package into the existing GitHub repository and inspect relative links.

Keep the initial SN74HC path timing and the new FPGA implementation timing clearly separate.
