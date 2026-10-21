`timescale 1ns/1ps
// FSM Moore: controlador de barrera. Traduccion de M1_* de Logisim.
module moore (
    input  logic CLK,
    input  logic RST,
    input  logic SENSOR,
    input  logic OK,
    output logic CERRADA,
    output logic ABRIENDO,
    output logic ABIERTA,
    output logic CERRANDO,
    output logic Q1,
    output logic Q0
);
    logic D1, D0;

    // Compuertas de M1_next_state_logic, sin simplificar.
    assign D1 = (~Q1 & Q0)
              | ( Q1 & ~Q0)
              | ( Q1 & Q0 & SENSOR);
    assign D0 = (~Q1 & ~Q0 & OK)
              | ( Q1 & ~Q0 & ~SENSOR);

    // M1_registro_estado: reset asincrono activo alto.
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q1 <= 1'b0;
            Q0 <= 1'b0;
        end else begin
            Q1 <= D1;
            Q0 <= D0;
        end
    end

    // M1_output_logic: cuatro estados mutuamente excluyentes.
    assign CERRADA  = ~Q1 & ~Q0;
    assign ABRIENDO = ~Q1 &  Q0;
    assign ABIERTA  =  Q1 & ~Q0;
    assign CERRANDO =  Q1 &  Q0;
endmodule
