# Resumen del proyecto (español)

## Objetivo

Implementar un sistema de control de barrera de estacionamiento sobre la FPGA **Digilent Basys 3**, a partir de un diseño inicial elaborado en Logisim y migrado a SystemVerilog. La solución utiliza dos máquinas de estados finitos: **Mealy** para validar la secuencia A-C-B y **Moore** para controlar la barrera.

## Funcionamiento

- **SW0, SW1, SW2:** entradas A, B y C. Se ingresan una por una, subiendo y bajando el interruptor.
- **SW3:** simula un sensor que indica si hay un vehículo. En 1, la barrera permanece abierta; en 0, permite el cierre.
- **BTN_C:** reinicio.
- **LED0-LED3:** estados CERRADA, ABRIENDO, ABIERTA y CERRANDO.
- **LED4-LED9:** diagnóstico del código y bits de estado.

Se conserva el reloj de **100 MHz**, pero las FSM avanzan mediante una señal `clock enable` de **4 Hz**. Las entradas pasan por sincronización, filtrado antirrebote de **20 ms** y detección de evento por flanco. No hay un divisor de reloj físico independiente.

## Resultados medidos en Vivado 2018.1

| Parámetro | Resultado |
|:--|--:|
| Período del reloj | 10.000 ns |
| WNS (setup) | +5.669 ns |
| TNS | 0.000 ns |
| WHS (hold) | +0.122 ns |
| THS | 0.000 ns |
| Ancho de pulso | +4.500 ns |
| Fallos reportados | 0 |

El bitstream `top_basys3.bit` fue cargado mediante **Digilent FPGA Utility** y se reportó `done in 2.113 sec`.

Estos resultados están basados en las restricciones aplicadas al reloj. No demuestran por sí solos el comportamiento del sensor físico (simulado por SW3) ni el cumplimiento de retardos externos de entrada/salida.

## Evidencias

- [Simulación](../evidencias/fpga/01_simulacion_xsim.png)
- [RTL Analysis](../evidencias/fpga/02_rtl_elaborado.png)
- [Synthesis](../evidencias/fpga/05_sintesis_completada.png)
- [Implementation](../evidencias/fpga/03_implantacion_fpga.png)
- [Timing Analysis](../evidencias/fpga/06_timing_summary.png)
- [Programación física](../evidencias/fpga/07_programacion_exitosa.jpg)

Para ver la documentación completa y el código, vuelve al [README principal](../README.md).
