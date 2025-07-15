`timescale 1ns/1ps

module cpu_tb;
    reg clk;
    reg rst;
    wire [3:0] result;
    wire zero;
    wire carry;

    // Instantiate CPU
    cpu #(4) cpu_inst(
        .clk(clk),
        .rst(rst),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize waveform
        $dumpfile("waveform.vcd");
        $dumpvars(0, cpu_tb);

        // Reset
        rst = 1;
        #20;
        rst = 0;

        // Wait for operations to complete
        #200;

        // Verify results
        if (result === 4'b0011) begin
            $display("✅ Test passed! Final result is correct");
        end else begin
            $display("❌ Test failed! Expected 4'b0011, got %b", result);
        end

        // Check flags
        $display("Zero flag: %b", zero);
        $display("Carry flag: %b", carry);

        $finish;
    end

endmodule
