`timescale 1ns/1ps
// Entrada asincrona -> 2 FF sincronizadores -> antirrebote -> flanco ascendente.
module debounce_onepulse #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer DEBOUNCE_MS = 20
) (
    input  logic CLK,
    input  logic RST,
    input  logic RAW,
    output logic LEVEL,
    output logic RISE
);
    localparam integer SAMPLE_CYCLES = (CLK_HZ / 1000) * DEBOUNCE_MS;
    localparam integer WIDTH = (SAMPLE_CYCLES > 1) ? $clog2(SAMPLE_CYCLES) : 1;
    (* ASYNC_REG = "TRUE" *) logic meta = 0;
    (* ASYNC_REG = "TRUE" *) logic sync = 0;
    logic [WIDTH-1:0] count = '0;
    logic level_d = 0;

    always_ff @(posedge CLK) begin
        if (RST) begin
            meta <= 1'b0;
            sync <= 1'b0;
            LEVEL <= 1'b0;
            level_d <= 1'b0;
            count <= '0;
        end else begin
            meta <= RAW;
            sync <= meta;
            level_d <= LEVEL;
            if (sync == LEVEL) begin
                count <= '0;
            end else if (count == SAMPLE_CYCLES - 1) begin
                LEVEL <= sync;
                count <= '0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    assign RISE = LEVEL && !level_d;
endmodule
