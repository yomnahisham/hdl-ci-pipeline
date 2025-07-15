`timescale 1ns/1ps

module counter_tb;
    reg clk;
    reg rst_n;
    wire [3:0] count;

    // Instantiate the counter
    counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize
        rst_n = 0;

        // Enable waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, counter_tb);

        // Reset
        #20;
        rst_n = 1;

        // Let it count for a while
        #100;

        // Check final value
        if (count !== 4'b1010) begin
            $display("Test failed: count = %b", count);
            $finish;
        end

        $display("Test passed!");
        $finish;
    end

endmodule
