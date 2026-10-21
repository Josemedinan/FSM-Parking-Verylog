# P2 - Analisis temporal de FSM Moore

## Circuito analizado

Fuente: `circuito/barrera_codigo(1).circ` (Logisim). Se analiza un camino de realimentacion del estado Q1 al registro D1 de la FSM Moore.

Ruta: FF(Q1) -> NOT(Q1) -> AND -> OR -> OR -> FF(D1).

La puerta OR de tres entradas del esquema de Logisim se implementa en este ejemplo con dos puertas OR de dos entradas. Se supone que la asignacion de ambas OR coloca la rama examinada a traves de las dos etapas (caso conservador).

Ver: `evidencias/logica_moore.png` y `evidencias/registros_moore.png`.

## Componentes seleccionados

Componentes de la familia SN74HC de Texas Instruments disponibles a traves de distribuidores de componentes como DigiKey:

| Elemento | Parte | Funcion | Retardo de referencia |
|---|---|---|---|
| FF | SN74HC74N | D flip-flop | CLK->Q max 44 ns; setup 25 ns; hold 0 ns |
| NOT | SN74HC04N | inversor | tpd max 24 ns |
| AND | SN74HC08N | AND 2 entradas | tpd max 25 ns |
| OR | SN74HC32N | OR 2 entradas | tpd max 25 ns, por nivel |

Condiciones de referencia: VCC=4.5 V, TA=-40 a 85 grados Celsius. Las cifras proceden de las tablas de temporizacion de TI; aplican las condiciones de carga y prueba de cada ficha. Los retardos de cable, diferencias de carga y skew del reloj no se han cuantificado.

## Setup y Fmax del camino seleccionado

Tclk >= tCQ,max + tNOT,max + tAND,max + 2*tOR,max + tsetup

Tclk >= 44 + 24 + 25 + (2*25) + 25 = **168 ns**

Fmax,ruta = 1 / (168e-9) = **5.952 MHz**.

Este resultado es una cota aproximada calculada para una ruta con dos niveles de OR; **NO** representa una medicion fisica ni la Fmax del circuito global Mealy+Moore. Para la Fmax global se deben examinar todos los caminos y las condiciones electricas de la implementacion final.

## Hold

Se requiere: tCQ,min + tCD,min >= thold + tskew (convencion de skew: captura menos lanzamiento).

Con tskew = 0 y thold = 0 ns (SN74HC74), la ruta satisface la desigualdad suponiendo retardos fisicos no negativos. **No es posible certificar un margen numerico positivo** porque no contamos con limites minimos garantizados para todas las compuertas.

## Fuentes oficiales

- TI SN74HC74: https://www.ti.com/lit/gpn/sn74hc74
- TI SN74HC04: https://www.ti.com/lit/ds/symlink/sn74hc04.pdf
- TI SN74HC08: https://www.ti.com/lit/gpn/sn74hc08
- TI SN74HC32: https://www.ti.com/lit/gpn/sn74hc32
- Distribuidor DigiKey: https://www.digikey.com/

## Reproduccion

1. Abrir circuito en Logisim Evolution y observar `M1_next_state_logic` y `M1_registro_estado`.
2. Seguir la ruta Q1 -> Q1' -> AND superior -> OR D1.
3. Para materializar OR de tres entradas con SN74HC32, usar dos niveles OR de dos entradas.
4. Aplicar los valores maximos de retardos y el setup indicados.
5. Verificar independientemente los demas caminos secuenciales antes de declarar la Fmax global.
