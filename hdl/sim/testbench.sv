`timescale 1ns/1ps
// Test de la FSM original: CE=1 equivale a un avance por cada reloj.
module testbench;
    logic CLK = 0, RST = 1, CE = 1, SENSOR = 0, A = 0, B = 0, C = 0;
    wire CERRADA, ABRIENDO, ABIERTA, CERRANDO;
    wire CODIGO_OK, ALARMA, PASO_1, PASO_2, Q1, Q0;
    top dut (.*);
    always #5 CLK = ~CLK;

    task automatic tecla(input logic aa, bb, cc);
        @(negedge CLK);
        {A,B,C} = {aa,bb,cc};
        @(posedge CLK);
        #1;
        @(negedge CLK);
        {A,B,C} = 3'b000;
    endtask

    initial begin
        $dumpfile("fsm_p2.vcd");
        $dumpvars(0,testbench);
        repeat (2) @(posedge CLK);
        #1 RST = 0;
        @(negedge CLK);
        if (!CERRADA) $fatal(1,"Moore no inicio cerrada");
        tecla(1,0,0); // A
        if (!PASO_1) $fatal(1,"No se registro A");
        tecla(0,0,1); // C
        if (!PASO_2) $fatal(1,"No se registro A,C");
        @(negedge CLK);
        B = 1;
        #1;
        if (!CODIGO_OK) $fatal(1,"A,C,B no habilita CODIGO_OK");
        @(posedge CLK);
        #1;
        if (!ABRIENDO) $fatal(1,"Moore no paso a ABRIENDO");
        @(negedge CLK); B=0;
        @(posedge CLK);
        #1;
        if (!ABIERTA) $fatal(1,"Moore no paso a ABIERTA");
        SENSOR = 1;
        @(posedge CLK);
        #1;
        if (!ABIERTA) $fatal(1,"Con SENSOR=1 debe permanecer abierta");
        @(negedge CLK); SENSOR=0;
        @(posedge CLK);
        #1;
        if (!CERRANDO) $fatal(1,"Moore no paso a CERRANDO");
        @(posedge CLK);
        #1;
        if (!CERRADA) $fatal(1,"Moore no regreso a CERRADA");
        $display("PASS: secuencia A-C-B y ciclo de barrera");
        $finish;
    end
endmodule
