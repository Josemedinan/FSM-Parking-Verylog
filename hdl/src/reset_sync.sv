`timescale 1ns/1ps
// Asercion asincrona del reset, liberacion sincronizada a CLK.
module reset_sync (
    input  logic CLK,
    input  logic RST_RAW,
    output logic RST
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] pipe = 2'b11;
    always_ff @(posedge CLK or posedge RST_RAW) begin
        if (RST_RAW)
            pipe <= 2'b11;
        else
            pipe <= {pipe[0], 1'b0};
    end
    assign RST = pipe[1];
endmodule
