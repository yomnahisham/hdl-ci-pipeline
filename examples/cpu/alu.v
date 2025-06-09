module alu #(
    parameter WIDTH = 4
)(
    input wire [WIDTH-1:0] a,      // First operand
    input wire [WIDTH-1:0] b,      // Second operand
    input wire [2:0] op,           // Operation select
    output reg [WIDTH-1:0] result, // Result
    output reg zero,               // Zero flag
    output reg carry               // Carry flag
);

    // Operation codes
    localparam ADD  = 3'b000;  // Addition
    localparam SUB  = 3'b001;  // Subtraction
    localparam AND  = 3'b010;  // Bitwise AND
    localparam OR   = 3'b011;  // Bitwise OR
    localparam XOR  = 3'b100;  // Bitwise XOR
    localparam NOT  = 3'b101;  // Bitwise NOT
    localparam SHL  = 3'b110;  // Shift left
    localparam SHR  = 3'b111;  // Shift right

    // Temporary signals for arithmetic operations
    wire [WIDTH:0] add_result;
    wire [WIDTH:0] sub_result;

    // Calculate addition and subtraction
    assign add_result = a + b;
    assign sub_result = a - b;

    // Main ALU logic
    always @(*) begin
        case (op)
            ADD: begin
                result = add_result[WIDTH-1:0];
                carry = add_result[WIDTH];
                zero = (result == 0);
            end

            SUB: begin
                result = sub_result[WIDTH-1:0];
                carry = sub_result[WIDTH];
                zero = (result == 0);
            end

            AND: begin
                result = a & b;
                carry = 0;
                zero = (result == 0);
            end

            OR: begin
                result = a | b;
                carry = 0;
                zero = (result == 0);
            end

            XOR: begin
                result = a ^ b;
                carry = 0;
                zero = (result == 0);
            end

            NOT: begin
                result = ~a;
                carry = 0;
                zero = (result == 0);
            end

            SHL: begin
                result = {a[WIDTH-2:0], 1'b0};
                carry = a[WIDTH-1];
                zero = (result == 0);
            end

            SHR: begin
                result = {1'b0, a[WIDTH-1:1]};
                carry = a[0];
                zero = (result == 0);
            end

            default: begin
                result = 0;
                carry = 0;
                zero = 1;
            end
        endcase
    end

endmodule