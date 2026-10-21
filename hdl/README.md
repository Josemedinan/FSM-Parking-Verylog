# P2 - Migracion de Logisim a SystemVerilog

## Procedencia y estructura
Se transcribieron las compuertas de `barrera_codigo(1).circ`:
- `src/moore.sv`: M1_registro_estado, M1_next_state_logic, M1_output_logic.
- `src/mealy.sv`: M2_registro_estado, M2_next_state_logic, M2_output_logic.
- `src/top.sv`: instancia ambas FSM; conecta `CERRADA -> EN` y `CODIGO_OK -> OK`.
- `sim/testbench.sv`: prueba basica de la secuencia A, C, B y la apertura/cierre.

Moore codifica `00=CERRADA`, `01=ABRIENDO`, `10=ABIERTA`, `11=CERRANDO`. Su reset es asincrono activo alto. Mealy codifica `00=espera`, `01=A`, `10=A,C`; su reset es sincronico y esta implementado en las expresiones D. Las salidas Mealy son combinacionales.

## Ecuaciones transcritas
```text
Moore:
D1 = (!Q1 & Q0) | (Q1 & !Q0) | (Q1 & Q0 & SENSOR)
D0 = (!Q1 & !Q0 & OK) | (Q1 & !Q0 & !SENSOR)

Mealy:
D1 = (!RST & EN & !P1 & P0 & C) | (!RST & EN & P1 & !P0 & !A & !B)
D0 = (!RST & EN & !P1 & !P0 & A) | (!RST & EN & !P1 & P0 & !B & !C)
CODIGO_OK = EN & P1 & !P0 & B & !A & !C
ALARMA = (EN & !P1 & !P0 & B) | (EN & !P1 & !P0 & C) | (EN & !P1 & P0 & B) | (EN & P1 & !P0 & A)
PASO_1 = !P1 & P0; PASO_2 = P1 & !P0
```

## Vivado
1. Create Project > RTL Project; agregar `src/top.sv`, `src/mealy.sv`, `src/moore.sv` como Design Sources.
2. Set as Top > `top`.
3. Add Sources > Add or Create Simulation Sources > `sim/testbench.sv`.
4. Set as Top (Simulation) > `testbench`.
5. Run Simulation > Run Behavioral Simulation; inspeccionar CLK, RST, A, B, C, Q1, Q0, CODIGO_OK y las cuatro salidas Moore.

**Advertencias:** no se ha realizado implementacion ni temporizacion en FPGA. El testbench no sustituye una verificacion exhaustiva. Los pulsadores fisicos de Basys3 requieren sincronizacion y antirrebote; el reloj de la FPGA y el mapeo XDC se trabajaran aparte.

## Git en CMD (desde la carpeta del repositorio existente)
Copiar `src/`, `sim/` y este archivo README (preferiblemente bajo una carpeta `hdl/`) al repositorio ya clonado y ejecutar:
```cmd
git add .
git commit -m "Agrega FSM Mealy y Moore en SystemVerilog"
git push
```
