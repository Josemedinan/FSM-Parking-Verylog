`timescale 1ns/1ps
// TOP FISICO: mismo mapa XDC ya empleado en Vivado.
// SW0=A, SW1=B, SW2=C, SW3=SENSOR, BTN_C=RST.
// 100 MHz siempre en CLK. CE de 4 Hz para visualizar FSM.
module top_basys3 #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer DEBOUNCE_MS = 20,
    parameter integer FSM_HZ = 4
) (
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
    logic rst_clean;
    logic ce;
    logic a_level, b_level, c_level, sensor_level;
    logic a_rise, b_rise, c_rise;
    logic sensor_rise_unused;
    logic pending_a = 0, pending_b = 0, pending_c = 0;
    logic key_a, key_b, key_c;

    reset_sync u_reset_sync (
        .CLK(CLK), .RST_RAW(RST), .RST(rst_clean)
    );
    tick_enable #(.CLK_HZ(CLK_HZ), .TICK_HZ(FSM_HZ)) u_tick (
        .CLK(CLK), .RST(rst_clean), .CE(ce)
    );
    debounce_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) u_a (
        .CLK(CLK), .RST(rst_clean), .RAW(A), .LEVEL(a_level), .RISE(a_rise)
    );
    debounce_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) u_b (
        .CLK(CLK), .RST(rst_clean), .RAW(B), .LEVEL(b_level), .RISE(b_rise)
    );
    debounce_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) u_c (
        .CLK(CLK), .RST(rst_clean), .RAW(C), .LEVEL(c_level), .RISE(c_rise)
    );
    debounce_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(DEBOUNCE_MS)) u_sensor (
        .CLK(CLK), .RST(rst_clean), .RAW(SENSOR),
        .LEVEL(sensor_level), .RISE(sensor_rise_unused)
    );

    // Retener una tecla hasta el siguiente tick; se consume UNA SOLA vez.
    // Si se pulsan varias teclas en el mismo intervalo, puede ser invalido:
    // ingresar la secuencia A, C, B de una en una.
    always_ff @(posedge CLK) begin
        if (rst_clean) begin
            pending_a <= 1'b0;
            pending_b <= 1'b0;
            pending_c <= 1'b0;
        end else if (ce) begin
            pending_a <= 1'b0;
            pending_b <= 1'b0;
            pending_c <= 1'b0;
        end else begin
            if (a_rise) pending_a <= 1'b1;
            if (b_rise) pending_b <= 1'b1;
            if (c_rise) pending_c <= 1'b1;
        end
    end
    assign key_a = pending_a | a_rise;
    assign key_b = pending_b | b_rise;
    assign key_c = pending_c | c_rise;

    top u_core (
        .CLK(CLK), .RST(rst_clean), .CE(ce), .SENSOR(sensor_level),
        .A(key_a), .B(key_b), .C(key_c),
        .CERRADA(CERRADA), .ABRIENDO(ABRIENDO), .ABIERTA(ABIERTA),
        .CERRANDO(CERRANDO), .CODIGO_OK(CODIGO_OK), .ALARMA(ALARMA),
        .PASO_1(PASO_1), .PASO_2(PASO_2), .Q1(Q1), .Q0(Q0)
    );
endmodule
