`timescale 1ns/1ps
`include "../src/top_CORDIC_Engine_v1.v"
`include "../src/CORDIC_Engine_v1.v"
`include "../src/dynamic_atan.v"

module tb_top_CORDIC_Engine_v1();

    reg i_clk;
    reg i_rst_n;
    
    reg signed [DATA_WIDTH - 1 : 0] in_x;
    reg signed [DATA_WIDTH - 1 : 0] in_y;
    reg signed [DATA_WIDTH - 1 : 0] in_alpha;
    reg [DATA_WIDTH -1 : 0] in_atan_0;
    reg i_valid_in;

    wire signed [DATA_WIDTH - 1 : 0] out_costheta;
    wire signed [DATA_WIDTH - 1 : 0] out_sintheta;
    wire signed [DATA_WIDTH - 1 : 0] out_alpha;
    wire o_valid_out;

    initial i_clk = 1'b1;
    always #5 i_clk = ~i_clk;

    localparam DATA_WIDTH = 16;
    localparam N_PE = 13;

    top_CORDIC_Engine_v1 # (
        .DATA_WIDTH(DATA_WIDTH),
        .N_PE(N_PE)
    )
    top_CORDIC_Engine_v1_inst (
      .i_clk(i_clk),
      .i_rst_n(i_rst_n),
      .in_x(in_x),
      .in_y(in_y),
      .in_alpha(in_alpha),
      .in_atan_0(in_atan_0),
      .i_valid_in(i_valid_in),
      .out_costheta(out_costheta),
      .out_sintheta(out_sintheta),
      .out_alpha(out_alpha),
      .o_valid_out(o_valid_out)
    );

    real absolute_error_cos_theta = 0;
    real absolute_error_sin_theta = 0;

    // alpha is the angle in radians, represented in fixed-point format
    integer f1,f2,f3;
    initial begin

        $dumpfile("tb_top_CORDIC_Engine_v1.vcd");
        $dumpvars(0);

        f1 = $fopen("input_angle.txt", "r");
        f2 = $fopen("cos_output.txt", "w");
        f3 = $fopen("sin_output.txt", "w");

        if (f1 == 0 || f2 == 0 || f3 == 0) begin
            $display("Error opening file");
            $finish;
        end
        i_rst_n = 1'b0;
        i_valid_in = 1'b0;
        in_x = 0;
        in_y = 0;
        in_alpha = 0;
        in_atan_0 = 0;

        #10 i_rst_n = 1'b1;
            in_x = 16'h09b7; // Scaling value for CORDIC 0.60729
            in_y = 16'h0000;
            in_atan_0 = 16'h0c91;
        
        while(!$feof(f1)) begin
            i_valid_in = 1'b1;
            $fscanf(f1, "%b\n", in_alpha);
            #10 i_valid_in = 1'b0;
            wait(o_valid_out) // Wait for the CORDIC computation to finish
            $fwrite(f2, "%h\n", out_costheta);
            $fwrite(f3, "%h\n", out_sintheta);
        end
        
        $fclose(f1);
        $fclose(f2);
        $fclose(f3);
        
        $display("Simulation finished successfully.\n");
        $display("Analyzing results...");

        f1 = $fopen("input_angle.txt", "r");
        f2 = $fopen("cos_output.txt", "r");
        f3 = $fopen("sin_output.txt", "r");

        while(!$feof(f1)) begin
            reg signed [DATA_WIDTH - 1 : 0] r_in_alpha;
            reg signed [DATA_WIDTH - 1 : 0] r_out_costheta;
            reg signed [DATA_WIDTH - 1 : 0] r_out_sintheta;

            $fscanf(f1, "%b\n", r_in_alpha);
            $fscanf(f2, "%h\n", r_out_costheta);
            $fscanf(f3, "%h\n", r_out_sintheta);

            $display("--------------------------------------------");
            $display("Input angle    : dec=%0d hex=%h -> rad=%f", r_in_alpha, r_in_alpha, r_in_alpha / (2**12.0));
            $display("Expected       : cos=%f sin=%f", $cos(r_in_alpha/2**12.0), $sin(r_in_alpha/2**12.0));
            $display("CORDIC Cosine  : dec=%0d hex=%h -> val=%f", r_out_costheta, r_out_costheta, r_out_costheta / (2**12.0));
            $display("CORDIC Sine    : dec=%0d hex=%h -> val=%f\n", r_out_sintheta, r_out_sintheta, r_out_sintheta / (2**12.0));

            /* ------------------- Calculation of Error between Expected and Computed Values --------------------- */
            if(($cos(r_in_alpha/2**12.0) - r_out_costheta / (2**12.0)) >= 0)
                absolute_error_cos_theta = absolute_error_cos_theta + ($cos(r_in_alpha/2**12.0) - r_out_costheta / (2**12.0));
            else
                absolute_error_cos_theta = absolute_error_cos_theta + (r_out_costheta / (2**12.0) - $cos(r_in_alpha/2**12.0));

            if(($sin(r_in_alpha/2**12.0) - r_out_sintheta / (2**12.0)) >= 0)
                absolute_error_sin_theta = absolute_error_sin_theta + ($sin(r_in_alpha/2**12.0) - r_out_sintheta / (2**12.0));
            else
                absolute_error_sin_theta = absolute_error_sin_theta + (r_out_sintheta / (2**12.0) - $sin(r_in_alpha/2**12.0));
        end

        /* --------------- Mean Absolute Error --------------- */
        $display("MAE_Costheta = %f\n", absolute_error_cos_theta/1000);
        $display("MAE_sintheta = %f\n", absolute_error_sin_theta/1000);
        $finish;
    end

endmodule
