`timescale 1ns/1ps
// FSM Mealy: verificador de A -> C -> B.
// Se conserva la logica original; CE congela el estado entre ticks.
module mealy (
    input  logic CLK,
    input  logic RST,
    input  logic CE,
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

    assign D1 = (~RST & EN & ~P1 &  P0 & C)
              | (~RST & EN &  P1 & ~P0 & ~A & ~B);
    assign D0 = (~RST & EN & ~P1 & ~P0 & A)
              | (~RST & EN & ~P1 &  P0 & ~B & ~C);

    // El reset tiene prioridad sobre CE para responder inmediatamente.
    always_ff @(posedge CLK) begin
        if (RST) begin
            P1 <= 1'b0;
            P0 <= 1'b0;
        end else if (CE) begin
            P1 <= D1;
            P0 <= D0;
        end
    end

    assign CODIGO_OK = EN & P1 & ~P0 & B & ~A & ~C;
    assign ALARMA = (EN & ~P1 & ~P0 & B)
                  | (EN & ~P1 & ~P0 & C)
                  | (EN & ~P1 &  P0 & B)
                  | (EN &  P1 & ~P0 & A);
    assign PASO_1 = ~P1 & P0;
    assign PASO_2 = P1 & ~P0;
endmodule
