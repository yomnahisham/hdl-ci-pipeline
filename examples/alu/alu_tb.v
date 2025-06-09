module alu_tb;
    // Parameters
    parameter WIDTH = 4;
    parameter DELAY = 10;

    // Testbench signals
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg [2:0] op;
    wire [WIDTH-1:0] result;
    wire zero;
    wire carry;

    // Operation codes
    localparam ADD  = 3'b000;
    localparam SUB  = 3'b001;
    localparam AND  = 3'b010;
    localparam OR   = 3'b011;
    localparam XOR  = 3'b100;
    localparam NOT  = 3'b101;
    localparam SHL  = 3'b110;
    localparam SHR  = 3'b111;

    // Instantiate ALU
    alu #(
        .WIDTH(WIDTH)
    ) dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    // Test stimulus
    initial begin
        // Enable waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, alu_tb);
        
        // Initialize
        a = 0;
        b = 0;
        op = 0;
        
        // Test Addition
        $display("\nTesting Addition:");
        op = ADD;
        a = 4'b0101;  // 5
        b = 4'b0011;  // 3
        #DELAY;
        $display("5 + 3 = %d (Expected: 8)", result);
        $display("Carry: %b, Zero: %b", carry, zero);
        
        // Test Subtraction
        $display("\nTesting Subtraction:");
        op = SUB;
        a = 4'b1000;  // 8
        b = 4'b0011;  // 3
        #DELAY;
        $display("8 - 3 = %d (Expected: 5)", result);
        $display("Carry: %b, Zero: %b", carry, zero);
        
        // Test AND
        $display("\nTesting AND:");
        op = AND;
        a = 4'b1010;  // 10
        b = 4'b1100;  // 12
        #DELAY;
        $display("1010 & 1100 = %b (Expected: 1000)", result);
        
        // Test OR
        $display("\nTesting OR:");
        op = OR;
        a = 4'b1010;  // 10
        b = 4'b1100;  // 12
        #DELAY;
        $display("1010 | 1100 = %b (Expected: 1110)", result);
        
        // Test XOR
        $display("\nTesting XOR:");
        op = XOR;
        a = 4'b1010;  // 10
        b = 4'b1100;  // 12
        #DELAY;
        $display("1010 ^ 1100 = %b (Expected: 0110)", result);
        
        // Test NOT
        $display("\nTesting NOT:");
        op = NOT;
        a = 4'b1010;  // 10
        #DELAY;
        $display("~1010 = %b (Expected: 0101)", result);
        
        // Test Shift Left
        $display("\nTesting Shift Left:");
        op = SHL;
        a = 4'b1010;  // 10
        #DELAY;
        $display("1010 << 1 = %b (Expected: 0100)", result);
        $display("Carry: %b", carry);
        
        // Test Shift Right
        $display("\nTesting Shift Right:");
        op = SHR;
        a = 4'b1010;  // 10
        #DELAY;
        $display("1010 >> 1 = %b (Expected: 0101)", result);
        $display("Carry: %b", carry);
        
        // Test Zero Flag
        $display("\nTesting Zero Flag:");
        op = ADD;
        a = 4'b0000;  // 0
        b = 4'b0000;  // 0
        #DELAY;
        $display("0 + 0 = %d, Zero: %b (Expected: 0, 1)", result, zero);
        
        // Test Carry Flag
        $display("\nTesting Carry Flag:");
        op = ADD;
        a = 4'b1111;  // 15
        b = 4'b0001;  // 1
        #DELAY;
        $display("15 + 1 = %d, Carry: %b (Expected: 0, 1)", result, carry);
        
        // Test Edge Cases
        $display("\nTesting Edge Cases:");
        op = 3'bxxx;  // Invalid operation
        #DELAY;
        $display("Invalid operation result: %b, Zero: %b", result, zero);
        
        $display("\nAll tests completed!");
        #DELAY;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%t op=%b a=%b b=%b result=%b zero=%b carry=%b",
                 $time, op, a, b, result, zero, carry);
    end

endmodule 