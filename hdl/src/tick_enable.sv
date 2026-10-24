`timescale 1ns/1ps
// Divisor de frecuencia mediante clock-enable, NO genera otro reloj.
module tick_enable #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer TICK_HZ = 4
) (
    input  logic CLK,
    input  logic RST,
    output logic CE
);
    localparam integer DIVISOR = CLK_HZ / TICK_HZ;
    localparam integer WIDTH = (DIVISOR > 1) ? $clog2(DIVISOR) : 1;
    logic [WIDTH-1:0] count = '0;

    always_ff @(posedge CLK) begin
        if (RST) begin
            count <= '0;
        end else if (count == DIVISOR - 1) begin
            count <= '0;
        end else begin
            count <= count + 1'b1;
        end
    end
    // CE alto durante un ciclo de CLK (10 ns) cada 250 ms, a 4 Hz.
    assign CE = !RST && (count == DIVISOR - 1);
endmodule
