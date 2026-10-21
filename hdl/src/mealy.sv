`timescale 1ns/1ps
// FSM Mealy: verificador de A -> C -> B. Traduccion de M2_* de Logisim.
module mealy (
    input  logic CLK,
    input  logic RST,
    input  logic A,
    input  logic B,
    input  logic C,
    input  logic EN,
    output logic CODIGO_OK,
    output logic ALARMA,
    output logic PASO_1,
    output logic PASO_2
);
    logic P1, P0;
    logic D1, D0;

    // M2_next_state_logic: reset sincronico, incluido en las ecuaciones.
    assign D1 = (~RST & EN & ~P1 &  P0 & C)
              | (~RST & EN &  P1 & ~P0 & ~A & ~B);
    assign D0 = (~RST & EN & ~P1 & ~P0 & A)
              | (~RST & EN & ~P1 &  P0 & ~B & ~C);

    // M2_registro_estado: dos flip-flops D sin clear asincrono.
    always_ff @(posedge CLK) begin
        P1 <= D1;
        P0 <= D0;
    end

    // M2_output_logic: salidas combinacionales (Mealy).
    assign CODIGO_OK = EN & P1 & ~P0 & B & ~A & ~C;
    assign ALARMA = (EN & ~P1 & ~P0 & B)
                  | (EN & ~P1 & ~P0 & C)
                  | (EN & ~P1 &  P0 & B)
                  | (EN &  P1 & ~P0 & A);
    assign PASO_1 = ~P1 & P0;
    assign PASO_2 = P1 & ~P0;
endmodule
