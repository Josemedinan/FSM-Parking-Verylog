`timescale 1ns/1ps
// Integracion exacta del circuito 'top' de barrera_codigo(1).circ.
module top (
    input  logic CLK,
    input  logic RST,
    input  logic SENSOR,
    input  logic A,
    input  logic B,
    input  logic C,
    output logic CERRADA,
    output logic ABRIENDO,
    output logic ABIERTA,
    output logic CERRANDO,
    output logic CODIGO_OK,
    output logic ALARMA,
    output logic PASO_1,
    output logic PASO_2,
    output logic Q1,
    output logic Q0
);
    // CERRADA habilita el teclado; CODIGO_OK activa el avance Moore.
    moore u_moore (
        .CLK(CLK), .RST(RST), .SENSOR(SENSOR), .OK(CODIGO_OK),
        .CERRADA(CERRADA), .ABRIENDO(ABRIENDO), .ABIERTA(ABIERTA),
        .CERRANDO(CERRANDO), .Q1(Q1), .Q0(Q0)
    );
    mealy u_mealy (
        .CLK(CLK), .RST(RST), .A(A), .B(B), .C(C), .EN(CERRADA),
        .CODIGO_OK(CODIGO_OK), .ALARMA(ALARMA),
        .PASO_1(PASO_1), .PASO_2(PASO_2)
    );
endmodule
