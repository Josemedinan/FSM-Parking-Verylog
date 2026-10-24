`timescale 1ns/1ps
// Prueba de integracion: parametros reducidos solo para la simulacion.
module testbench_basys3;
    logic CLK = 0, RST = 1, SENSOR = 0, A = 0, B = 0, C = 0;
    wire CERRADA, ABRIENDO, ABIERTA, CERRANDO;
    wire CODIGO_OK, ALARMA, PASO_1, PASO_2, Q1, Q0;

    // Para acelerar la simulacion: 50 ciclos por tick, 5 para antirrebote.
    top_basys3 #(.CLK_HZ(1000), .DEBOUNCE_MS(5), .FSM_HZ(20)) dut (.*);
    always #5 CLK = ~CLK;

    task automatic wait_for_paso1;
        integer k;
        begin
            k = 0;
            while (!PASO_1 && k < 200) begin @(negedge CLK); k = k + 1; end
            if (!PASO_1) $fatal(1,"Timeout PASO_1");
        end
    endtask
    task automatic wait_for_paso2;
        integer k;
        begin
            k = 0;
            while (!PASO_2 && k < 200) begin @(negedge CLK); k = k + 1; end
            if (!PASO_2) $fatal(1,"Timeout PASO_2");
        end
    endtask
    task automatic wait_for_abriendo;
        integer k;
        begin
            k = 0;
            while (!ABRIENDO && k < 200) begin @(negedge CLK); k = k + 1; end
            if (!ABRIENDO) $fatal(1,"Timeout ABRIENDO");
        end
    endtask
    task automatic wait_for_abierta;
        integer k;
        begin
            k = 0;
            while (!ABIERTA && k < 200) begin @(negedge CLK); k = k + 1; end
            if (!ABIERTA) $fatal(1,"Timeout ABIERTA");
        end
    endtask
    task automatic wait_for_cerrando;
        integer k;
        begin
            k = 0;
            while (!CERRANDO && k < 200) begin @(negedge CLK); k = k + 1; end
            if (!CERRANDO) $fatal(1,"Timeout CERRANDO");
        end
    endtask

    initial begin
        $dumpfile("testbench_basys3.vcd");
        $dumpvars(0,testbench_basys3);
        repeat (5) @(negedge CLK);
        RST = 0;
        repeat (5) @(negedge CLK);
        if (!CERRADA) $fatal(1,"El sistema no inicia cerrado");

        // SENSOR=1 antes de ingresar el codigo: mantiene abierta la barrera.
        SENSOR = 1;
        repeat (12) @(negedge CLK);
        if (!dut.sensor_level) $fatal(1,"SENSOR no fue debounced");

        // Rebote corto de A: no debe procesarse antes de estabilidad.
        A = 1; repeat(2) @(negedge CLK);
        A = 0; repeat(2) @(negedge CLK);
        if (PASO_1) $fatal(1,"Rebote corto de A fue aceptado");
        A = 1;
        wait_for_paso1();
        repeat (60) @(negedge CLK);
        if (!PASO_1) $fatal(1,"A sostenida conto mas de una vez");
        A = 0;
        repeat (12) @(negedge CLK);

        C = 1;
        wait_for_paso2();
        C = 0;
        repeat (12) @(negedge CLK);

        B = 1;
        wait_for_abriendo();
        B = 0;
        wait_for_abierta();
        repeat (120) @(negedge CLK);
        if (!ABIERTA) $fatal(1,"No mantuvo ABIERTA con SENSOR=1");

        SENSOR = 0;
        wait_for_cerrando();
        begin : wait_closed
            integer k;
            k=0;
            while (!CERRADA && k<200) begin @(negedge CLK);k=k+1;end
            if (!CERRADA) $fatal(1,"No regreso a CERRADA");
        end
        $display("PASS: antirrebote, one-shot, CE lento, codigo A-C-B y barrera");
        $finish;
    end
endmodule
