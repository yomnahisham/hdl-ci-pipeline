`timescale 1ns/1ps

module cpu #(
    parameter integer WIDTH = 4
)(
    input wire clk,
    input wire rst,
    output wire [WIDTH-1:0] result,
    output wire zero,
    output wire carry
);

    // Registers
    reg [WIDTH-1:0] reg_a;
    reg [WIDTH-1:0] reg_b;
    reg [WIDTH-1:0] reg_result;
    reg [2:0] op_code;

    // ALU instance
    alu #(WIDTH) alu_inst(
        .a(reg_a),
        .b(reg_b),
        .op(op_code),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    // State machine
    reg [2:0] state;
    localparam logic [2:0] IDLE = 3'b000;
    localparam logic [2:0] ADD = 3'b001;
    localparam logic [2:0] STORE = 3'b010;
    localparam logic [2:0] SUB = 3'b011;
    localparam logic [2:0] AND = 3'b100;
    localparam logic [2:0] DONE = 3'b101;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            reg_a <= 0;
            reg_b <= 0;
            op_code <= 0;
        end else begin
            case (state)
                IDLE: begin
                    reg_a <= 4'b1010;  // 10 in decimal
                    reg_b <= 4'b0101;  // 5 in decimal
                    op_code <= 3'b000; // ADD
                    state <= ADD;
                end

                ADD: begin
                    reg_result <= result;
                    state <= STORE;
                end

                STORE: begin
                    reg_a <= reg_result;
                    reg_b <= 4'b0011;  // 3 in decimal
                    op_code <= 3'b001; // SUB
                    state <= SUB;
                end

                SUB: begin
                    reg_result <= result;
                    state <= AND;
                end

                AND: begin
                    reg_a <= reg_result;
                    reg_b <= 4'b1111;  // All ones
                    op_code <= 3'b010; // AND
                    state <= DONE;
                end

                DONE: begin
                    state <= DONE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
